use std::fs;
use std::path::{Path, PathBuf};
use crate::StorageError;

pub struct WiiUMlcStorage {
    root: PathBuf,
}

impl WiiUMlcStorage {
    pub fn new(base_path: impl AsRef<Path>) -> Result<Self, StorageError> {
        let root = base_path.as_ref().join("wiiu").join("mlc");
        let save_dir = root.join("usr").join("save").join("00050000");
        fs::create_dir_all(&save_dir)?;
        Ok(Self { root })
    }

    pub fn get_save_dir(&self, title_id: &str) -> PathBuf {
        self.root.join("usr").join("save").join("00050000").join(title_id).join("user")
    }

    pub fn write_meta_xml(&self, title_id: &str, xml_data: &str) -> Result<(), StorageError> {
        let meta_dir = self.root.join("usr").join("save").join("00050000").join(title_id).join("meta");
        fs::create_dir_all(&meta_dir)?;
        let file_path = meta_dir.join("meta.xml");
        crate::atomic_file::write_atomic(&file_path, xml_data.as_bytes())?;
        Ok(())
    }

    pub fn write_save_file(&self, title_id: &str, file_name: &str, data: &[u8]) -> Result<(), StorageError> {
        let dir = self.get_save_dir(title_id);
        fs::create_dir_all(&dir)?;
        let file_path = dir.join(file_name);
        crate::atomic_file::write_atomic(&file_path, data)?;
        Ok(())
    }

    pub fn read_save_file(&self, title_id: &str, file_name: &str) -> Result<Vec<u8>, StorageError> {
        let file_path = self.get_save_dir(title_id).join(file_name);
        fs::read(file_path).map_err(StorageError::from)
    }
}
