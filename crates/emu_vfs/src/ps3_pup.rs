use crate::VfsError;
use std::fs::{self, File};
use std::io::{Read, Seek, SeekFrom, Write};
use std::path::Path;

#[derive(Debug, Clone)]
pub struct PupEntry {
    pub id: u64,
    pub offset: u64,
    pub size: u64,
}

pub struct PupExtractor;

impl PupExtractor {
    pub const PUP_MAGIC: &'static [u8; 8] = b"SCEUF\x00\x00\x00";

    pub fn extract(pup_path: &Path, flash_dir: &Path) -> Result<usize, VfsError> {
        let mut file = File::open(pup_path)?;
        let mut header = [0u8; 32];
        file.read_exact(&mut header)?;

        if &header[0..5] != b"SCEUF" {
            return Err(VfsError::FirmwareMissing("Invalid PUP firmware header".into()));
        }

        let num_files = u64::from_be_bytes(header[16..24].try_into().unwrap()) as usize;
        let mut entries = Vec::new();

        for _ in 0..num_files {
            let mut entry_buf = [0u8; 32];
            file.read_exact(&mut entry_buf)?;
            let id = u64::from_be_bytes(entry_buf[0..8].try_into().unwrap());
            let offset = u64::from_be_bytes(entry_buf[8..16].try_into().unwrap());
            let size = u64::from_be_bytes(entry_buf[16..24].try_into().unwrap());
            entries.push(PupEntry { id, offset, size });
        }

        fs::create_dir_all(flash_dir.join("sys").join("external"))?;
        let extracted_count = entries.len();

        for entry in &entries {
            file.seek(SeekFrom::Start(entry.offset))?;
            let mut buf = vec![0u8; std::cmp::min(entry.size, 1024 * 1024) as usize];
            let _ = file.read(&mut buf);

            let out_file = flash_dir.join(format!("module_{:04X}.sprx", entry.id));
            let mut out = File::create(out_file)?;
            out.write_all(&buf)?;
        }

        Ok(extracted_count)
    }
}
