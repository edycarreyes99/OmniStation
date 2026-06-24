use crate::{IDiscImageReader, VfsError};
use memmap2::Mmap;
use std::collections::HashMap;
use std::fs::File;
use std::path::Path;

pub struct Iso9660Reader {
    mmap: Mmap,
    sector_size: usize,
    total_sectors: u64,
    file_map: HashMap<String, (u64, u64)>, // Name -> (LBA, Length)
}

impl Iso9660Reader {
    pub fn open(path: &Path) -> Result<Self, VfsError> {
        let file = File::open(path)?;
        let len = file.metadata()?.len();
        if len < 32768 {
            return Err(VfsError::CorruptMedia("ISO image too small".into()));
        }
        let mmap = unsafe { Mmap::map(&file)? };

        // Determine raw 2352 (BIN) vs 2048 (ISO)
        let sector_size = if len % 2352 == 0 && &mmap[0x10..0x15] != b"CD001" {
            2352
        } else {
            2048
        };

        let total_sectors = len / (sector_size as u64);
        let mut reader = Self {
            mmap,
            sector_size,
            total_sectors,
            file_map: HashMap::new(),
        };

        reader.parse_volume_descriptor()?;
        Ok(reader)
    }

    fn parse_volume_descriptor(&mut self) -> Result<(), VfsError> {
        // Sector 16 contains Primary Volume Descriptor
        let offset = 16 * self.sector_size;
        if self.mmap.len() < offset + 2048 {
            return Err(VfsError::CorruptMedia("Missing Primary Volume Descriptor".into()));
        }

        let pvd = &self.mmap[offset..offset + 2048];
        if &pvd[1..6] != b"CD001" {
            return Err(VfsError::CorruptMedia("Invalid ISO-9660 magic".into()));
        }

        // Root directory record is at offset 156 in PVD
        let root_record = &pvd[156..156 + 34];
        let root_lba = u32::from_le_bytes(root_record[2..6].try_into().unwrap()) as u64;
        let root_len = u32::from_le_bytes(root_record[10..14].try_into().unwrap()) as u64;

        self.read_directory(root_lba, root_len)?;
        Ok(())
    }

    fn read_directory(&mut self, lba: u64, len: u64) -> Result<(), VfsError> {
        let offset = (lba * (self.sector_size as u64)) as usize;
        if offset + (len as usize) > self.mmap.len() {
            return Ok(());
        }

        let dir_data = &self.mmap[offset..offset + (len as usize)];
        let mut cursor = 0;

        while cursor < dir_data.len() {
            let record_len = dir_data[cursor] as usize;
            if record_len == 0 {
                // Advance to next sector boundary if zero-padding
                cursor = ((cursor / self.sector_size) + 1) * self.sector_size;
                continue;
            }

            if cursor + record_len > dir_data.len() {
                break;
            }

            let entry = &dir_data[cursor..cursor + record_len];
            let file_lba = u32::from_le_bytes(entry[2..6].try_into().unwrap()) as u64;
            let file_len = u32::from_le_bytes(entry[10..14].try_into().unwrap()) as u64;
            let flags = entry[25];
            let name_len = entry[32] as usize;

            if cursor + 33 + name_len <= cursor + record_len {
                let raw_name = &entry[33..33 + name_len];
                let mut name = String::from_utf8_lossy(raw_name).to_string();
                // Strip revision ;1
                if let Some(pos) = name.find(';') {
                    name.truncate(pos);
                }
                let clean_name = name.trim().to_uppercase();

                if (flags & 0x02) == 0 && !clean_name.is_empty() && clean_name != "\0" && clean_name != "\x01" {
                    self.file_map.insert(clean_name, (file_lba, file_len));
                }
            }

            cursor += record_len;
        }

        Ok(())
    }

    pub fn has_file(&self, filename: &str) -> bool {
        self.file_map.contains_key(&filename.to_uppercase())
    }

    pub fn read_file_string(&self, filename: &str) -> Result<String, VfsError> {
        let (lba, len) = self
            .file_map
            .get(&filename.to_uppercase())
            .copied()
            .ok_or_else(|| VfsError::CorruptMedia(format!("File not found in ISO: {}", filename)))?;

        let offset = (lba * (self.sector_size as u64)) as usize;
        let data = &self.mmap[offset..offset + (len as usize)];
        Ok(String::from_utf8_lossy(data).to_string())
    }
}

impl IDiscImageReader for Iso9660Reader {
    fn sector_size(&self) -> usize {
        self.sector_size
    }

    fn sector_count(&self) -> u64 {
        self.total_sectors
    }

    fn read_sector(&self, lba: u64, buf: &mut [u8]) -> Result<(), VfsError> {
        if lba >= self.total_sectors {
            return Err(VfsError::DiscReadError {
                lba,
                msg: "LBA out of bounds".into(),
            });
        }
        let offset = (lba * (self.sector_size as u64)) as usize;
        let raw_sector = &self.mmap[offset..offset + self.sector_size];
        let out_len = std::cmp::min(buf.len(), self.sector_size);
        buf[..out_len].copy_from_slice(&raw_sector[..out_len]);
        Ok(())
    }
}
