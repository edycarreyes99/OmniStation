pub mod chd;
pub mod cso_zso;
pub mod iso9660;
pub mod ps3_pkg;
pub mod ps3_pup;
pub mod ps3_self;
pub mod ps3_sfo;
pub mod snes_header;
pub mod udf250;

use std::path::Path;
use thiserror::Error;

#[derive(Error, Debug)]
pub enum VfsError {
    #[error("Disc read error at LBA {lba}: {msg}")]
    DiscReadError { lba: u64, msg: String },

    #[error("UDF 2.50 filesystem parse failed: {0}")]
    UdfParseError(String),

    #[error("ISO decryption failed: {0}")]
    IsoDecryptionError(String),

    #[error("PARAM.SFO parse failed: {0}")]
    ParamSfoError(String),

    #[error("SELF/SPRX decryption failed: {0}")]
    SelfDecryptionError(String),

    #[error("PKG missing RAP license: {0}")]
    PkgRapMissing(String),

    #[error("Firmware or BIOS missing: {0}")]
    FirmwareMissing(String),

    #[error("Corrupted media image: {0}")]
    CorruptMedia(String),

    #[error("I/O error: {0}")]
    IoError(#[from] std::io::Error),
}

impl VfsError {
    pub fn error_code(&self) -> &'static str {
        match self {
            VfsError::DiscReadError { .. } => "errorDiscRead",
            VfsError::UdfParseError(_) => "errorUdfFs",
            VfsError::IsoDecryptionError(_) => "errorIsoDecryption",
            VfsError::ParamSfoError(_) => "errorParamSfo",
            VfsError::SelfDecryptionError(_) => "errorSelfDecryption",
            VfsError::PkgRapMissing(_) => "errorPkgRapMissing",
            VfsError::FirmwareMissing(_) => "errorFirmwareMissing",
            VfsError::CorruptMedia(_) => "errorDiscRead",
            VfsError::IoError(_) => "errorUnknown",
        }
    }
}

pub trait IDiscImageReader: Send + Sync {
    fn sector_size(&self) -> usize;
    fn sector_count(&self) -> u64;
    fn read_sector(&self, lba: u64, buf: &mut [u8]) -> Result<(), VfsError>;
    fn read_bytes(&self, offset: u64, buf: &mut [u8]) -> Result<(), VfsError> {
        let sec_sz = self.sector_size() as u64;
        let mut bytes_read = 0;
        let total = buf.len() as u64;

        while bytes_read < total {
            let cur_offset = offset + bytes_read;
            let lba = cur_offset / sec_sz;
            let sec_offset = (cur_offset % sec_sz) as usize;
            let mut sec_buf = vec![0u8; sec_sz as usize];
            self.read_sector(lba, &mut sec_buf)?;

            let available = (sec_sz as usize) - sec_offset;
            let to_copy = std::cmp::min(available, (total - bytes_read) as usize);
            buf[bytes_read as usize..bytes_read as usize + to_copy]
                .copy_from_slice(&sec_buf[sec_offset..sec_offset + to_copy]);
            bytes_read += to_copy as u64;
        }
        Ok(())
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum MediaType {
    SnesRom,
    Ps1Disc,
    Ps2Disc,
    Ps3BluRay,
    Ps3Pkg,
    Ps3Self,
    Ps3Pup,
}

pub fn detect_media_type(path: &Path) -> Result<MediaType, VfsError> {
    let ext = path
        .extension()
        .and_then(|s| s.to_str())
        .unwrap_or("")
        .to_lowercase();

    match ext.as_str() {
        "sfc" | "smc" | "msc" => Ok(MediaType::SnesRom),
        "pkg" => Ok(MediaType::Ps3Pkg),
        "self" | "sprx" => Ok(MediaType::Ps3Self),
        "pup" => Ok(MediaType::Ps3Pup),
        "zip" => {
            // Inspect ZIP archive local file header
            let file = std::fs::File::open(path)?;
            let len = file.metadata()?.len();
            if len < 30 {
                return Err(VfsError::CorruptMedia("Zip archive too small".into()));
            }
            let mut header = [0u8; 1024];
            let read_len = std::cmp::min(len as usize, 1024);
            use std::io::Read;
            let mut f = file;
            f.read_exact(&mut header[..read_len])?;
            if &header[0..4] != b"PK\x03\x04" {
                return Err(VfsError::CorruptMedia("Invalid ZIP signature".into()));
            }
            let name_len = u16::from_le_bytes([header[26], header[27]]) as usize;
            if 30 + name_len <= read_len {
                let inner_name = String::from_utf8_lossy(&header[30..30 + name_len]).to_lowercase();
                if inner_name.ends_with(".sfc") || inner_name.ends_with(".smc") || inner_name.ends_with(".msc") {
                    return Ok(MediaType::SnesRom);
                } else if inner_name.ends_with(".pkg") {
                    return Ok(MediaType::Ps3Pkg);
                } else if inner_name.ends_with(".bin") || inner_name.ends_with(".cue") || inner_name.ends_with(".iso") {
                    if len > 700 * 1024 * 1024 {
                        return Ok(MediaType::Ps2Disc);
                    } else {
                        return Ok(MediaType::Ps1Disc);
                    }
                }
            }
            // Fallback for zip based on uncompressed/compressed size
            if len > 700 * 1024 * 1024 {
                Ok(MediaType::Ps2Disc)
            } else if len > 64 * 1024 * 1024 {
                Ok(MediaType::Ps1Disc)
            } else {
                Ok(MediaType::SnesRom)
            }
        }
        "iso" | "bin" | "img" | "chd" | "cso" | "zso" => {
            // Inspect headers using memory map
            let file = std::fs::File::open(path)?;
            let len = file.metadata()?.len();
            if len == 0 {
                return Err(VfsError::CorruptMedia("Empty media file".into()));
            }
            if len > 50 * 1024 * 1024 * 1024 {
                return Err(VfsError::CorruptMedia("Disc exceeds 50GB dual-layer BD limit".into()));
            }

            if len >= 32768 {
                let mmap = unsafe { memmap2::MmapOptions::new().len(std::cmp::min(len, 0x100000) as usize).map(&file)? };

                // Check ISO9660 Volume Descriptor at offset 0x8000 (Sector 16 * 2048)
                if mmap.len() >= 0x8006 && &mmap[0x8001..0x8006] == b"CD001" {
                    // Check if it's PS1 or PS2 via SYSTEM.CNF
                    let reader = iso9660::Iso9660Reader::open(path)?;
                    if reader.has_file("SYSTEM.CNF") {
                        let content = reader.read_file_string("SYSTEM.CNF").unwrap_or_default();
                        if content.contains("BOOT2") {
                            return Ok(MediaType::Ps2Disc);
                        } else if content.contains("BOOT") {
                            return Ok(MediaType::Ps1Disc);
                        }
                    }
                    return Ok(MediaType::Ps2Disc);
                }

                // Check if UDF 2.50 Blu-ray
                if udf250::Udf250Reader::probe_udf(&mmap) {
                    return Ok(MediaType::Ps3BluRay);
                }
            }

            // Default fallback based on size
            if len > 700 * 1024 * 1024 {
                Ok(MediaType::Ps2Disc)
            } else {
                Ok(MediaType::Ps1Disc)
            }
        }
        _ => Err(VfsError::CorruptMedia(format!("Unsupported file extension: {}", ext))),
    }
}
