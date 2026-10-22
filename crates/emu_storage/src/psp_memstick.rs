use std::fs;
use std::path::{Path, PathBuf};
use crate::StorageError;

pub struct PspMemoryStick {
    root: PathBuf,
}

impl PspMemoryStick {
    pub fn new(base_path: impl AsRef<Path>) -> Result<Self, StorageError> {
        let root = base_path.as_ref().join("psp").join("ms0");
        let savedata = root.join("PSP").join("SAVEDATA");
        fs::create_dir_all(&savedata)?;
        Ok(Self { root })
    }

    pub fn get_savedata_path(&self, title_id: &str) -> PathBuf {
        self.root.join("PSP").join("SAVEDATA").join(title_id)
    }

    pub fn save_exists(&self, title_id: &str) -> bool {
        self.get_savedata_path(title_id).exists()
    }

    pub fn write_save_data(&self, title_id: &str, file_name: &str, data: &[u8]) -> Result<(), StorageError> {
        let dir = self.get_savedata_path(title_id);
        fs::create_dir_all(&dir)?;
        let file_path = dir.join(file_name);
        crate::atomic_file::write_atomic(&file_path, data)?;
        Ok(())
    }

    pub fn read_save_data(&self, title_id: &str, file_name: &str) -> Result<Vec<u8>, StorageError> {
        let file_path = self.get_savedata_path(title_id).join(file_name);
        fs::read(file_path).map_err(StorageError::from)
    }
}
