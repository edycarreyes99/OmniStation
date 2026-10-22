use crate::VfsError;
use std::fs::{self, File};
use std::io::{Read, Write};
use std::path::Path;

#[derive(Debug, Clone)]
pub struct PkgInfo {
    pub content_id: String,
    pub title_id: String,
    pub pkg_type: u32,
    pub item_count: u32,
    pub total_size: u64,
}

pub struct PkgInstaller;

impl PkgInstaller {
    pub const PKG_MAGIC: &'static [u8; 4] = b"\x7FPKG";

    pub fn inspect(path: &Path) -> Result<PkgInfo, VfsError> {
        let mut file = File::open(path)?;
        let mut header = [0u8; 128];
        file.read_exact(&mut header)?;

        if &header[0..4] != Self::PKG_MAGIC {
            return Err(VfsError::CorruptMedia("Not a valid PS3 PKG file".into()));
        }

        let pkg_type = u32::from_be_bytes(header[4..8].try_into().unwrap());
        let item_count = u32::from_be_bytes(header[20..24].try_into().unwrap());
        let total_size = u64::from_be_bytes(header[24..32].try_into().unwrap());

        let content_id_raw = &header[48..48 + 36];
        let content_id = String::from_utf8_lossy(content_id_raw).trim().to_string();

        let title_id = if content_id.len() >= 16 {
            content_id[7..16].to_string()
        } else {
            "UNKNOWN00".to_string()
        };

        Ok(PkgInfo {
            content_id,
            title_id,
            pkg_type,
            item_count,
            total_size,
        })
    }

    pub fn install_pkg(
        pkg_path: &Path,
        hdd_root: &Path,
        rap_path: Option<&Path>,
    ) -> Result<String, VfsError> {
        let info = Self::inspect(pkg_path)?;
        let target_dir = hdd_root.join("game").join(&info.title_id);
        fs::create_dir_all(&target_dir)?;

        // If RAP license provided, install to exdata
        if let Some(rap) = rap_path {
            let exdata_dir = hdd_root.join("home/00000001/exdata");
            fs::create_dir_all(&exdata_dir)?;
            let rap_name = rap.file_name().unwrap();
            fs::copy(rap, exdata_dir.join(rap_name))?;
        }

        // Install synthetic PARAM.SFO and USRDIR structure
        let usrdir = target_dir.join("USRDIR");
        fs::create_dir_all(&usrdir)?;

        let mut sfo_file = File::create(target_dir.join("PARAM.SFO"))?;
        // Minimal valid PSF structure
        let mut sfo_binary = vec![
            0x00, 0x50, 0x53, 0x46, 0x01, 0x01, 0x00, 0x00,
            0x24, 0x00, 0x00, 0x00, 0x30, 0x00, 0x00, 0x00,
            0x01, 0x00, 0x00, 0x00,
            // Entry 0: TITLE_ID
            0x00, 0x00, 0x04, 0x02, 0x0A, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ];
        // Key table: "TITLE_ID\0"
        sfo_binary.extend_from_slice(b"TITLE_ID\x00\x00\x00\x00");
        // Data table: title_id
        let mut id_bytes = info.title_id.as_bytes().to_vec();
        id_bytes.resize(16, 0);
        sfo_binary.extend_from_slice(&id_bytes);

        sfo_file.write_all(&sfo_binary)?;

        // Create EBOOT.BIN stub
        let mut eboot = File::create(usrdir.join("EBOOT.BIN"))?;
        eboot.write_all(b"SCE\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00")?;

        Ok(info.title_id)
    }
}
