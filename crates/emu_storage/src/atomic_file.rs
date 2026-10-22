use std::fs::{self, File};
use std::io::{self, Write};
use std::path::{Path, PathBuf};

pub struct AtomicFile {
    target_path: PathBuf,
    temp_path: PathBuf,
    is_dirty: bool,
}

impl AtomicFile {
    pub fn new(path: impl AsRef<Path>) -> Self {
        let target_path = path.as_ref().to_path_buf();
        let mut temp_path = target_path.clone();
        temp_path.set_extension("tmp");
        Self {
            target_path,
            temp_path,
            is_dirty: false,
        }
    }

    pub fn mark_dirty(&mut self) {
        self.is_dirty = true;
    }

    pub fn is_dirty(&self) -> bool {
        self.is_dirty
    }

    pub fn write_atomic(&mut self, data: &[u8]) -> io::Result<()> {
        if let Some(parent) = self.target_path.parent() {
            fs::create_dir_all(parent)?;
        }

        // 1. Write data to temporary file
        let mut file = File::create(&self.temp_path)?;
        file.write_all(data)?;
        
        // 2. Perform sync (fsync / FlushFileBuffers)
        file.sync_all()?;
        drop(file);

        // 3. Atomically rename temporary file over target file
        fs::rename(&self.temp_path, &self.target_path)?;
        self.is_dirty = false;
        Ok(())
    }

    pub fn read(&self) -> io::Result<Vec<u8>> {
        fs::read(&self.target_path)
    }

    pub fn exists(&self) -> bool {
        self.target_path.exists()
    }
}
