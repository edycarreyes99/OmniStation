use std::fs;
use std::path::{Path, PathBuf};
use crate::StorageError;

pub struct PsVitaMemoryCard {
    root: PathBuf,
}

impl PsVitaMemoryCard {
    pub fn new(base_path: impl AsRef<Path>) -> Result<Self, StorageError> {
        let root = base_path.as_ref().join("psvita").join("ux0");
        let savedata = root.join("user").join("00").join("savedata");
        fs::create_dir_all(&savedata)?;
        Ok(Self { root })
    }

    pub fn get_savedata_path(&self, title_id: &str) -> PathBuf {
        self.root.join("user").join("00").join("savedata").join(title_id)
    }

    pub fn write_save_chunk(&self, title_id: &str, file_name: &str, data: &[u8]) -> Result<(), StorageError> {
        let dir = self.get_savedata_path(title_id);
        fs::create_dir_all(&dir)?;
        let target = dir.join(file_name);
        crate::atomic_file::write_atomic(&target, data)?;
        Ok(())
    }

    pub fn read_save_chunk(&self, title_id: &str, file_name: &str) -> Result<Vec<u8>, StorageError> {
        let target = self.get_savedata_path(title_id).join(file_name);
        fs::read(target).map_err(StorageError::from)
    }
}
