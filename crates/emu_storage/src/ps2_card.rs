use crate::atomic_file::AtomicFile;
use std::io;
use std::path::Path;

pub const PS2_PAGE_DATA_SIZE: usize = 512;
pub const PS2_PAGE_SPARE_SIZE: usize = 16;
pub const PS2_RAW_PAGE_SIZE: usize = PS2_PAGE_DATA_SIZE + PS2_PAGE_SPARE_SIZE; // 528 bytes
pub const PS2_PAGES_PER_CLUSTER: usize = 2;
pub const PS2_CLUSTER_SIZE: usize = PS2_PAGE_DATA_SIZE * PS2_PAGES_PER_CLUSTER; // 1024 bytes
pub const PS2_TOTAL_CLUSTERS: usize = 8192; // 8 MB card
pub const PS2_CARD_SIZE: usize = PS2_TOTAL_CLUSTERS * PS2_CLUSTER_SIZE;

pub struct Ps2MemoryCard {
    data: Vec<u8>,
    atomic_file: AtomicFile,
    magicgate_authenticated: bool,
}

impl Ps2MemoryCard {
    pub const SUPERBLOCK_MAGIC: &[u8; 28] = b"Sony PS2 Memory Card Format ";

    pub fn new(path: impl AsRef<Path>) -> Self {
        let mut atomic_file = AtomicFile::new(path);
        let mut data = vec![0u8; PS2_CARD_SIZE];

        if atomic_file.exists() {
            if let Some(bytes) = atomic_file.read().ok().filter(|b| b.len() == PS2_CARD_SIZE) {
                data = bytes;
            }
        } else {
            Self::format_raw(&mut data);
            let _ = atomic_file.write_atomic(&data);
        }

        Self {
            data,
            atomic_file,
            magicgate_authenticated: false,
        }
    }

    pub fn format_raw(data: &mut [u8]) {
        data.fill(0xFF);
        // Superblock at cluster 0 (page 0)
        data[0..28].copy_from_slice(Self::SUPERBLOCK_MAGIC);
        // Version "1.2.0.0"
        data[28..35].copy_from_slice(b"1.2.0.0");
        // Page size: 512 bytes (LE u16)
        data[40..42].copy_from_slice(&(PS2_PAGE_DATA_SIZE as u16).to_le_bytes());
        // Pages per cluster: 2 (LE u16)
        data[42..44].copy_from_slice(&(PS2_PAGES_PER_CLUSTER as u16).to_le_bytes());
        // Total clusters: 8192 (LE u32)
        data[48..52].copy_from_slice(&(PS2_TOTAL_CLUSTERS as u32).to_le_bytes());
        // Root directory cluster: 8
        data[64..68].copy_from_slice(&8u32.to_le_bytes());
    }

    pub fn read_page(&self, page_index: usize, out_512: &mut [u8; PS2_PAGE_DATA_SIZE]) -> io::Result<()> {
        let offset = page_index * PS2_PAGE_DATA_SIZE;
        if offset + PS2_PAGE_DATA_SIZE > self.data.len() {
            return Err(io::Error::new(io::ErrorKind::InvalidInput, "PS2 page index out of bounds"));
        }
        out_512.copy_from_slice(&self.data[offset..offset + PS2_PAGE_DATA_SIZE]);
        Ok(())
    }

    pub fn write_page(&mut self, page_index: usize, in_512: &[u8; PS2_PAGE_DATA_SIZE]) -> io::Result<()> {
        let offset = page_index * PS2_PAGE_DATA_SIZE;
        if offset + PS2_PAGE_DATA_SIZE > self.data.len() {
            return Err(io::Error::new(io::ErrorKind::InvalidInput, "PS2 page index out of bounds"));
        }
        self.data[offset..offset + PS2_PAGE_DATA_SIZE].copy_from_slice(in_512);
        self.atomic_file.mark_dirty();
        Ok(())
    }

    pub fn authenticate_magicgate(&mut self, challenge: &[u8; 8]) -> [u8; 8] {
        // Deterministic MagicGate handshake response
        let mut response = [0u8; 8];
        for i in 0..8 {
            response[i] = challenge[i] ^ 0x5A;
        }
        self.magicgate_authenticated = true;
        response
    }

    pub fn flush(&mut self) -> io::Result<()> {
        if self.atomic_file.is_dirty() {
            self.atomic_file.write_atomic(&self.data)?;
        }
        Ok(())
    }

    pub fn format(&mut self) -> io::Result<()> {
        Self::format_raw(&mut self.data);
        self.atomic_file.write_atomic(&self.data)
    }
}
