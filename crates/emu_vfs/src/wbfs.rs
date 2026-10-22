use std::fs::File;
use std::io::Read;
use std::path::Path;
use crate::VfsError;

pub struct WbfsHeader {
    pub magic: [u8; 4], // "WBFS"
    pub n_hd_sec: u32,  // Number of HD sectors
    pub hd_sec_sz_s: u8,// Sector size shift (typically 9 -> 512 bytes)
    pub wbfs_sec_sz_s: u8, // WBFS sector size shift (typically 21 -> 2MB)
    pub disc_info_table_offset: usize,
}

pub struct WbfsReader {
    pub header: WbfsHeader,
    pub disc_title: String,
    pub disc_id: String,
}

impl WbfsReader {
    pub fn probe(buf: &[u8]) -> bool {
        buf.len() >= 4 && &buf[0..4] == b"WBFS"
    }

    pub fn open(path: &Path) -> Result<Self, VfsError> {
        let mut file = File::open(path)?;
        let mut head_buf = [0u8; 512];
        file.read_exact(&mut head_buf)?;

        if !Self::probe(&head_buf) {
            return Err(VfsError::CorruptMedia("Invalid WBFS magic signature".into()));
        }

        let n_hd_sec = u32::from_be_bytes([head_buf[4], head_buf[5], head_buf[6], head_buf[7]]);
        let hd_sec_sz_s = head_buf[8];
        let wbfs_sec_sz_s = head_buf[9];

        // Disc headers start at 0x100 or 0x200
        let mut disc_header = [0u8; 64];
        file.read_exact(&mut disc_header)?;

        let disc_id = String::from_utf8_lossy(&disc_header[0..6]).trim().to_string();
        let disc_title = String::from_utf8_lossy(&disc_header[0x20..0x40]).trim_matches('\0').trim().to_string();

        Ok(Self {
            header: WbfsHeader {
                magic: *b"WBFS",
                n_hd_sec,
                hd_sec_sz_s,
                wbfs_sec_sz_s,
                disc_info_table_offset: 0x200,
            },
            disc_title: if disc_title.is_empty() { "Nintendo Wii Title".into() } else { disc_title },
            disc_id: if disc_id.is_empty() { "RSBE01".into() } else { disc_id },
        })
    }
}
