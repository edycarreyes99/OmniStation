pub mod atomic_file;
pub mod ps1_card;
pub mod ps2_card;
pub mod ps3_hdd;
pub mod ps3_trophy;
pub mod save_state;
pub mod snes_sram;

use thiserror::Error;

#[derive(Error, Debug)]
pub enum StorageError {
    #[error("Memory card corrupt or invalid checksum")]
    MemoryCardCorrupt,

    #[error("PS3 save data verification failed (corrupted PARAM.PFD)")]
    Ps3SaveDataSignature,

    #[error("Incompatible save state version")]
    SaveStateVersion,

    #[error("I/O error: {0}")]
    Io(#[from] std::io::Error),
}

impl StorageError {
    pub fn error_code(&self) -> &'static str {
        match self {
            StorageError::MemoryCardCorrupt => "errorMemoryCardCorrupt",
            StorageError::Ps3SaveDataSignature => "errorPs3SaveDataSignature",
            StorageError::SaveStateVersion => "errorSaveStateVersion",
            StorageError::Io(_) => "errorUnknown",
        }
    }
}
