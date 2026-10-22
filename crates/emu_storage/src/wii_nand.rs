use std::fs;
use std::path::{Path, PathBuf};
use crate::StorageError;

pub struct WiiNandStorage {
    root: PathBuf,
}

impl WiiNandStorage {
    pub fn new(base_path: impl AsRef<Path>) -> Result<Self, StorageError> {
        let root = base_path.as_ref().join("wii").join("nand");
        let title_dir = root.join("title").join("00010000");
        fs::create_dir_all(&title_dir)?;
        Ok(Self { root })
    }

    pub fn get_title_data_dir(&self, title_id: &str) -> PathBuf {
        self.root.join("title").join("00010000").join(title_id).join("data")
    }

    pub fn write_banner_bin(&self, title_id: &str, data: &[u8]) -> Result<(), StorageError> {
        let dir = self.get_title_data_dir(title_id);
        fs::create_dir_all(&dir)?;
        let file_path = dir.join("banner.bin");
        crate::atomic_file::write_atomic(&file_path, data)?;
        Ok(())
    }

    pub fn write_data_bin(&self, title_id: &str, data: &[u8]) -> Result<(), StorageError> {
        let dir = self.get_title_data_dir(title_id);
        fs::create_dir_all(&dir)?;
        let file_path = dir.join("data.bin");
        crate::atomic_file::write_atomic(&file_path, data)?;
        Ok(())
    }

    pub fn read_data_bin(&self, title_id: &str) -> Result<Vec<u8>, StorageError> {
        let file_path = self.get_title_data_dir(title_id).join("data.bin");
        fs::read(file_path).map_err(StorageError::from)
    }
}
