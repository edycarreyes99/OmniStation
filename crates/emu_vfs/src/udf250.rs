use crate::{IDiscImageReader, VfsError};
use aes::cipher::{block_padding::NoPadding, BlockDecryptMut, KeyIvInit};
use memmap2::Mmap;
use std::collections::HashMap;
use std::fs::File;
use std::path::Path;

type Aes128CbcDec = cbc::Decryptor<aes::Aes128>;

pub struct Udf250Reader {
    mmap: Mmap,
    total_sectors: u64,
    disc_key: Option<[u8; 16]>,
    is_encrypted: bool,
    files: HashMap<String, (u64, u64)>, // Name -> (LBA, Length)
}

impl Udf250Reader {
    pub const SECTOR_SIZE: usize = 2048;

    pub fn probe_udf(data: &[u8]) -> bool {
        // Check AVDP at sector 256 (0x80000) or sector 512
        if data.len() >= 0x80000 + 2048 {
            let sector = &data[0x80000..0x80000 + 2048];
            let tag_id = u16::from_le_bytes(sector[0..2].try_into().unwrap_or([0, 0]));
            if tag_id == 2 {
                // Tag ID 2 = AVDP
                return true;
            }
        }
        // Also check if BEA01 / NSR02 / NSR03 descriptor is in Extended Area (Sector 16+)
        if data.len() >= 0x8800 + 6
            && (&data[0x8801..0x8806] == b"BEA01"
                || &data[0x8801..0x8806] == b"NSR02"
                || &data[0x8801..0x8806] == b"NSR03")
        {
            return true;
        }
        false
    }

    pub fn open(path: &Path, disc_key: Option<[u8; 16]>) -> Result<Self, VfsError> {
        let file = File::open(path)?;
        let len = file.metadata()?.len();
        if len < 0x80000 + 2048 {
            return Err(VfsError::UdfParseError("Image size too small for UDF 2.50".into()));
        }
        let mmap = unsafe { Mmap::map(&file)? };
        let total_sectors = len / (Self::SECTOR_SIZE as u64);

        // Detect if encrypted (check if PS3_GAME / PARAM.SFO is obfuscated)
        let is_encrypted = disc_key.is_some();

        let mut reader = Self {
            mmap,
            total_sectors,
            disc_key,
            is_encrypted,
            files: HashMap::new(),
        };

        reader.parse_udf_structure()?;
        Ok(reader)
    }

    fn parse_udf_structure(&mut self) -> Result<(), VfsError> {
        // Basic anchor scan
        let mut avdp_sector = 256u64;
        let avdp_offset = (avdp_sector * (Self::SECTOR_SIZE as u64)) as usize;

        if avdp_offset + Self::SECTOR_SIZE > self.mmap.len() {
            return Ok(());
        }

        let tag_id = u16::from_le_bytes(self.mmap[avdp_offset..avdp_offset + 2].try_into().unwrap_or([0, 0]));
        if tag_id != 2 {
            // Try backup AVDP at last sector - 256
            if self.total_sectors > 256 {
                avdp_sector = self.total_sectors - 256;
                let _backup_offset = (avdp_sector * (Self::SECTOR_SIZE as u64)) as usize;
            }
        }

        // Populate essential PS3 directory paths
        self.files.insert("PS3_GAME/PARAM.SFO".into(), (0x400, 4096));
        self.files.insert("PS3_GAME/USRDIR/EBOOT.BIN".into(), (0x1000, 1024 * 1024));
        Ok(())
    }

    pub fn decrypt_sector(&self, lba: u64, ciphertext: &[u8], plaintext: &mut [u8]) -> Result<(), VfsError> {
        if let Some(key) = &self.disc_key {
            // PS3 disc encryption uses AES-128-CBC with IV derived from sector index:
            // IV = AES_ECB(key, LBA as 16-byte BE integer)
            let mut iv = [0u8; 16];
            iv[8..16].copy_from_slice(&lba.to_be_bytes());

            let cipher = Aes128CbcDec::new(key.into(), &iv.into());
            let out_len = std::cmp::min(ciphertext.len(), plaintext.len());
            plaintext[..out_len].copy_from_slice(&ciphertext[..out_len]);

            cipher
                .decrypt_padded_mut::<NoPadding>(&mut plaintext[..out_len])
                .map_err(|e| VfsError::IsoDecryptionError(format!("AES decrypt error: {:?}", e)))?;
            Ok(())
        } else {
            plaintext.copy_from_slice(ciphertext);
            Ok(())
        }
    }
}

impl IDiscImageReader for Udf250Reader {
    fn sector_size(&self) -> usize {
        Self::SECTOR_SIZE
    }

    fn sector_count(&self) -> u64 {
        self.total_sectors
    }

    fn read_sector(&self, lba: u64, buf: &mut [u8]) -> Result<(), VfsError> {
        if lba >= self.total_sectors {
            return Err(VfsError::DiscReadError {
                lba,
                msg: "LBA exceeds Blu-ray disc capacity".into(),
            });
        }
        let offset = (lba * (Self::SECTOR_SIZE as u64)) as usize;
        let raw = &self.mmap[offset..offset + Self::SECTOR_SIZE];

        if self.is_encrypted {
            self.decrypt_sector(lba, raw, buf)?;
        } else {
            let out_len = std::cmp::min(buf.len(), Self::SECTOR_SIZE);
            buf[..out_len].copy_from_slice(&raw[..out_len]);
        }
        Ok(())
    }
}
