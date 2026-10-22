use hmac::{Hmac, Mac};
use sha1::Sha1;
use std::fs::{self, File};
use std::io::{self, Write};
use std::path::{Path, PathBuf};

type HmacSha1 = Hmac<Sha1>;

pub struct Ps3VirtualHdd {
    root_path: PathBuf,
}

impl Ps3VirtualHdd {
    // Standard PS3 SaveData HMAC key derived for PARAM.PFD
    pub const PFD_KEY: &'static [u8; 16] = b"\x54\x38\x3C\xF7\x37\x33\xA5\xBC\x29\x2C\x5C\x2A\xD4\x4E\x7B\xC1";

    pub fn new(root_path: impl AsRef<Path>) -> io::Result<Self> {
        let root = root_path.as_ref().to_path_buf();
        fs::create_dir_all(root.join("game"))?;
        fs::create_dir_all(root.join("home/00000001/savedata"))?;
        fs::create_dir_all(root.join("home/00000001/trophy"))?;
        fs::create_dir_all(root.join("home/00000001/exdata"))?;
        Ok(Self { root_path: root })
    }

    pub fn get_savedata_path(&self, dir_name: &str) -> PathBuf {
        self.root_path.join("home/00000001/savedata").join(dir_name)
    }

    pub fn write_save_entry(
        &self,
        dir_name: &str,
        file_name: &str,
        data: &[u8],
    ) -> io::Result<()> {
        let save_dir = self.get_savedata_path(dir_name);
        fs::create_dir_all(&save_dir)?;

        // Write the data file
        let target_file = save_dir.join(file_name);
        let mut f = File::create(&target_file)?;
        f.write_all(data)?;
        f.sync_all()?;

        // Generate / Update cryptographic PARAM.PFD signature
        self.sign_pfd(&save_dir)?;
        Ok(())
    }

    pub fn read_save_entry(&self, dir_name: &str, file_name: &str) -> io::Result<Vec<u8>> {
        let target_file = self.get_savedata_path(dir_name).join(file_name);
        fs::read(target_file)
    }

    pub fn sign_pfd(&self, save_dir: &Path) -> io::Result<()> {
        let mut mac = HmacSha1::new_from_slice(Self::PFD_KEY)
            .map_err(|e| io::Error::other(format!("HMAC init failed: {:?}", e)))?;

        // Hash all files in directory except PARAM.PFD itself
        let mut entries: Vec<_> = fs::read_dir(save_dir)?
            .filter_map(|e| e.ok())
            .filter(|e| e.file_name() != "PARAM.PFD")
            .collect();
        entries.sort_by_key(|e| e.file_name());

        for entry in entries {
            let path = entry.path();
            if path.is_file() {
                let bytes = fs::read(&path)?;
                mac.update(&bytes);
            }
        }

        let signature = mac.finalize().into_bytes();

        // Write valid PFD header + signature
        let pfd_path = save_dir.join("PARAM.PFD");
        let mut pfd_file = File::create(pfd_path)?;
        let mut pfd_content = vec![0u8; 128];
        pfd_content[0..4].copy_from_slice(b"PFD\x00");
        pfd_content[4..8].copy_from_slice(&3u32.to_be_bytes()); // Version 3
        pfd_content[16..36].copy_from_slice(&signature);
        pfd_file.write_all(&pfd_content)?;
        pfd_file.sync_all()?;
        Ok(())
    }

    pub fn verify_pfd(&self, save_dir: &Path) -> io::Result<bool> {
        let pfd_path = save_dir.join("PARAM.PFD");
        if !pfd_path.exists() {
            return Ok(false);
        }

        let pfd_bytes = fs::read(pfd_path)?;
        if pfd_bytes.len() < 36 || &pfd_bytes[0..4] != b"PFD\x00" {
            return Ok(false);
        }

        let stored_sig = &pfd_bytes[16..36];

        let mut mac = HmacSha1::new_from_slice(Self::PFD_KEY)
            .map_err(|e| io::Error::other(format!("HMAC init failed: {:?}", e)))?;

        let mut entries: Vec<_> = fs::read_dir(save_dir)?
            .filter_map(|e| e.ok())
            .filter(|e| e.file_name() != "PARAM.PFD")
            .collect();
        entries.sort_by_key(|e| e.file_name());

        for entry in entries {
            let path = entry.path();
            if path.is_file() {
                let bytes = fs::read(&path)?;
                mac.update(&bytes);
            }
        }

        let expected_sig = mac.finalize().into_bytes();
        Ok(stored_sig == expected_sig.as_slice())
    }
}
