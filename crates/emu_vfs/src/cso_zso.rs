use crate::{IDiscImageReader, VfsError};
use flate2::read::DeflateDecoder;
use std::fs::File;
use std::io::{Read, Seek, SeekFrom};
use std::path::Path;

pub struct CsoZsoReader {
    file: File,
    block_size: u32,
    total_sectors: u64,
    index_shift: u8,
    index_table: Vec<u32>,
    #[allow(dead_code)]
    is_zso: bool,
}

impl CsoZsoReader {
    pub const CSO_MAGIC: &'static [u8; 4] = b"CISO";
    pub const ZSO_MAGIC: &'static [u8; 4] = b"ZISO";

    pub fn open(path: &Path) -> Result<Self, VfsError> {
        let mut file = File::open(path)?;
        let mut header = [0u8; 24];
        file.read_exact(&mut header)?;

        let is_zso = &header[0..4] == Self::ZSO_MAGIC;
        if !is_zso && &header[0..4] != Self::CSO_MAGIC {
            return Err(VfsError::CorruptMedia("Not a valid CSO or ZSO file".into()));
        }

        let header_size = u32::from_le_bytes(header[4..8].try_into().unwrap());
        let uncompressed_size = u64::from_le_bytes(header[8..16].try_into().unwrap());
        let block_size = u32::from_le_bytes(header[16..20].try_into().unwrap());
        let index_shift = header[20];

        let total_sectors = uncompressed_size / (block_size as u64);
        let num_blocks = (total_sectors + 1) as usize;

        file.seek(SeekFrom::Start(header_size as u64))?;
        let mut raw_indices = vec![0u8; num_blocks * 4];
        file.read_exact(&mut raw_indices)?;

        let mut index_table = Vec::with_capacity(num_blocks);
        for i in 0..num_blocks {
            let idx = u32::from_le_bytes(raw_indices[i * 4..(i + 1) * 4].try_into().unwrap());
            index_table.push(idx);
        }

        Ok(Self {
            file,
            block_size,
            total_sectors,
            index_shift,
            index_table,
            is_zso,
        })
    }
}

impl IDiscImageReader for CsoZsoReader {
    fn sector_size(&self) -> usize {
        self.block_size as usize
    }

    fn sector_count(&self) -> u64 {
        self.total_sectors
    }

    fn read_sector(&self, lba: u64, buf: &mut [u8]) -> Result<(), VfsError> {
        if lba >= self.total_sectors {
            return Err(VfsError::DiscReadError {
                lba,
                msg: "LBA out of bounds in CSO/ZSO".into(),
            });
        }

        let idx_entry = self.index_table[lba as usize];
        let next_entry = self.index_table[(lba + 1) as usize];

        let is_plain = (idx_entry & 0x80000000) != 0;
        let file_offset = ((idx_entry & 0x7FFFFFFF) as u64) << self.index_shift;
        let next_offset = ((next_entry & 0x7FFFFFFF) as u64) << self.index_shift;
        let compressed_len = (next_offset - file_offset) as usize;

        let mut file = &self.file;
        file.seek(SeekFrom::Start(file_offset))?;

        if is_plain {
            let out_len = std::cmp::min(buf.len(), self.block_size as usize);
            file.read_exact(&mut buf[..out_len])?;
        } else {
            let mut comp_data = vec![0u8; compressed_len];
            file.read_exact(&mut comp_data)?;

            let mut decoder = DeflateDecoder::new(&comp_data[..]);
            let out_len = std::cmp::min(buf.len(), self.block_size as usize);
            let _ = decoder.read(&mut buf[..out_len]);
        }

        Ok(())
    }
}
