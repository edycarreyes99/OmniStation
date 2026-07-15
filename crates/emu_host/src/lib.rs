pub mod scheduler;
pub mod session;
pub mod thread_pinning;

use thiserror::Error;

#[derive(Error, Debug)]
pub enum HostError {
    #[error("Core execution error: {0}")]
    CoreError(String),

    #[error("VFS error: {0}")]
    Vfs(#[from] emu_vfs::VfsError),

    #[error("Storage error: {0}")]
    Storage(#[from] emu_storage::StorageError),
}
