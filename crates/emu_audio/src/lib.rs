pub mod drc;
pub mod player;
pub mod ring_buffer;

use thiserror::Error;

#[derive(Error, Debug)]
pub enum AudioError {
    #[error("Audio sink initialization failed: {0}")]
    InitFailed(String),

    #[error("Dynamic Rate Control failed: {0}")]
    DrcError(String),
}

impl AudioError {
    pub fn error_code(&self) -> &'static str {
        match self {
            AudioError::InitFailed(_) => "errorAudioInit",
            AudioError::DrcError(_) => "errorAudioInit",
        }
    }
}
