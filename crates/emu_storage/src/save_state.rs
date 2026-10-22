use crate::atomic_file::AtomicFile;
use std::io::{self, Read};
use std::path::Path;

pub const SAVE_STATE_MAGIC: &[u8; 8] = b"OMNISTAT";
pub const SAVE_STATE_CURRENT_VERSION: u32 = 1;

#[derive(Debug, Clone)]
pub struct SaveStateHeader {
    pub magic: [u8; 8],
    pub version: u32,
    pub platform_id: u32, // 1=SNES, 2=PS1, 3=PS2, 4=PS3
    pub timestamp: u64,
    pub uncompressed_size: u64,
}

pub struct SaveStateManager;

impl SaveStateManager {
    pub fn save(
        path: impl AsRef<Path>,
        platform_id: u32,
        uncompressed_data: &[u8],
    ) -> io::Result<()> {
        let mut atomic_file = AtomicFile::new(path);
        let mut buffer = Vec::with_capacity(32 + uncompressed_data.len() / 2);

        // Header: 32 bytes
        buffer.extend_from_slice(SAVE_STATE_MAGIC);
        buffer.extend_from_slice(&SAVE_STATE_CURRENT_VERSION.to_le_bytes());
        buffer.extend_from_slice(&platform_id.to_le_bytes());
        let now = std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .map(|d| d.as_secs())
            .unwrap_or(0);
        buffer.extend_from_slice(&now.to_le_bytes());
        buffer.extend_from_slice(&(uncompressed_data.len() as u64).to_le_bytes());

        // Fast Zstd compression (Level 3 for sub-15ms speed)
        let compressed = zstd::stream::encode_all(uncompressed_data, 3)?;
        buffer.extend_from_slice(&compressed);

        atomic_file.write_atomic(&buffer)
    }

    pub fn load(path: impl AsRef<Path>, expected_platform: u32) -> io::Result<Vec<u8>> {
        let file_data = std::fs::read(path)?;
        if file_data.len() < 32 {
            return Err(io::Error::new(io::ErrorKind::InvalidData, "Save state file truncated"));
        }

        if &file_data[0..8] != SAVE_STATE_MAGIC {
            return Err(io::Error::new(io::ErrorKind::InvalidData, "Invalid save state magic header"));
        }

        let version = u32::from_le_bytes(file_data[8..12].try_into().unwrap());
        if version != SAVE_STATE_CURRENT_VERSION {
            return Err(io::Error::new(
                io::ErrorKind::InvalidData,
                format!("Incompatible save state version: {}", version),
            ));
        }

        let platform_id = u32::from_le_bytes(file_data[12..16].try_into().unwrap());
        if platform_id != expected_platform {
            return Err(io::Error::new(
                io::ErrorKind::InvalidData,
                format!("Platform ID mismatch: expected {}, got {}", expected_platform, platform_id),
            ));
        }

        let uncompressed_size = u64::from_le_bytes(file_data[24..32].try_into().unwrap()) as usize;
        let compressed_payload = &file_data[32..];

        let mut decompressed = Vec::with_capacity(uncompressed_size);
        let mut decoder = zstd::stream::Decoder::new(compressed_payload)?;
        decoder.read_to_end(&mut decompressed)?;

        Ok(decompressed)
    }
}
