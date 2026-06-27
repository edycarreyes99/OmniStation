use crate::{IDiscImageReader, VfsError};
use std::collections::HashMap;
use std::fs::File;
use std::io::{Read, Seek, SeekFrom};
use std::path::Path;

pub struct ChdV5Reader {
    file: File,
    hunk_bytes: u32,
    #[allow(dead_code)]
    hunk_count: u32,
    total_sectors: u64,
    sector_size: usize,
    hunk_map: Vec<u64>, // Offset of each hunk in CHD
    cached_hunks: HashMap<u32, Vec<u8>>,
}

impl ChdV5Reader {
    pub const CHD_V5_MAGIC: &'static [u8; 8] = b"MComprHD";

    pub fn open(path: &Path) -> Result<Self, VfsError> {
        let mut file = File::open(path)?;
        let mut header = [0u8; 124];
        file.read_exact(&mut header)?;

        if &header[0..8] != Self::CHD_V5_MAGIC {
            return Err(VfsError::CorruptMedia("Not a valid MAME CHD file".into()));
        }

        let version = u32::from_be_bytes(header[8..12].try_into().unwrap());
        if version != 5 {
            return Err(VfsError::CorruptMedia(format!("Unsupported CHD version: {}", version)));
        }

        let logical_bytes = u64::from_be_bytes(header[32..40].try_into().unwrap());
        let hunk_bytes = u32::from_be_bytes(header[56..60].try_into().unwrap());
        let unit_bytes = u32::from_be_bytes(header[60..64].try_into().unwrap());

        let sector_size = if unit_bytes > 0 { unit_bytes as usize } else { 2048 };
        let total_sectors = logical_bytes / (sector_size as u64);
        let hunk_count = logical_bytes.div_ceil(hunk_bytes as u64) as u32;

        let mut hunk_map = Vec::with_capacity(hunk_count as usize);
        let mut offset = 124u64;
        for _ in 0..hunk_count {
            hunk_map.push(offset);
            offset += hunk_bytes as u64; // In raw/uncompressed or indexed storage
        }

        Ok(Self {
            file,
            hunk_bytes,
            hunk_count,
            total_sectors,
            sector_size,
            hunk_map,
            cached_hunks: HashMap::new(),
        })
    }

    #[allow(dead_code)]
    fn load_hunk(&mut self, hunk_idx: u32) -> Result<&[u8], VfsError> {
        if hunk_idx >= self.hunk_count {
            return Err(VfsError::DiscReadError {
                lba: hunk_idx as u64,
                msg: "Hunk index out of bounds".into(),
            });
        }

        if !self.cached_hunks.contains_key(&hunk_idx) {
            let offset = self.hunk_map[hunk_idx as usize];
            self.file.seek(SeekFrom::Start(offset))?;
            let mut hunk_data = vec![0u8; self.hunk_bytes as usize];
            let _ = self.file.read(&mut hunk_data);
            self.cached_hunks.insert(hunk_idx, hunk_data);
        }

        Ok(self.cached_hunks.get(&hunk_idx).unwrap())
    }
}

impl IDiscImageReader for ChdV5Reader {
    fn sector_size(&self) -> usize {
        self.sector_size
    }

    fn sector_count(&self) -> u64 {
        self.total_sectors
    }

    fn read_sector(&self, lba: u64, buf: &mut [u8]) -> Result<(), VfsError> {
        let byte_offset = lba * (self.sector_size as u64);
        let hunk_idx = (byte_offset / (self.hunk_bytes as u64)) as u32;
        let in_hunk_offset = (byte_offset % (self.hunk_bytes as u64)) as usize;

        // Ensure hunk loaded
        if !self.cached_hunks.contains_key(&hunk_idx) {
            let offset = self.hunk_map.get(hunk_idx as usize).copied().unwrap_or(0);
            let mut file = &self.file;
            file.seek(SeekFrom::Start(offset))?;
            let mut data = vec![0u8; self.hunk_bytes as usize];
            let _ = file.read(&mut data);
            let out_len = std::cmp::min(buf.len(), self.sector_size);
            if in_hunk_offset + out_len <= data.len() {
                buf[..out_len].copy_from_slice(&data[in_hunk_offset..in_hunk_offset + out_len]);
            }
        } else {
            let data = self.cached_hunks.get(&hunk_idx).unwrap();
            let out_len = std::cmp::min(buf.len(), self.sector_size);
            if in_hunk_offset + out_len <= data.len() {
                buf[..out_len].copy_from_slice(&data[in_hunk_offset..in_hunk_offset + out_len]);
            }
        }

        Ok(())
    }
}
