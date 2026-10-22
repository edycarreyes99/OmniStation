use crate::atomic_file::AtomicFile;
use std::io;
use std::path::Path;

pub struct SnesSram {
    data: Vec<u8>,
    atomic_file: AtomicFile,
}

impl SnesSram {
    pub fn new(path: impl AsRef<Path>, sram_size: usize) -> Self {
        let atomic_file = AtomicFile::new(path);
        let mut data = vec![0u8; sram_size];

        if let Some(bytes) = atomic_file.read().ok().filter(|b| !b.is_empty()) {
            let copy_len = std::cmp::min(bytes.len(), sram_size);
            data[..copy_len].copy_from_slice(&bytes[..copy_len]);
        }

        Self { data, atomic_file }
    }

    pub fn read_byte(&self, address: usize) -> u8 {
        if address < self.data.len() {
            self.data[address]
        } else {
            0xFF
        }
    }

    pub fn write_byte(&mut self, address: usize, value: u8) {
        if address < self.data.len() {
            self.data[address] = value;
            self.atomic_file.mark_dirty();
        }
    }

    pub fn as_slice(&self) -> &[u8] {
        &self.data
    }

    pub fn as_mut_slice(&mut self) -> &mut [u8] {
        self.atomic_file.mark_dirty();
        &mut self.data
    }

    pub fn flush(&mut self) -> io::Result<()> {
        if self.atomic_file.is_dirty() && !self.data.is_empty() {
            self.atomic_file.write_atomic(&self.data)?;
        }
        Ok(())
    }
}
