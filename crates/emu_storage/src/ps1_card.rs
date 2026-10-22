use crate::atomic_file::AtomicFile;
use std::io;
use std::path::Path;

pub const PS1_CARD_SIZE: usize = 128 * 1024; // 131,072 bytes
pub const PS1_FRAME_SIZE: usize = 128; // 128 bytes per sector frame
pub const PS1_TOTAL_FRAMES: usize = PS1_CARD_SIZE / PS1_FRAME_SIZE; // 1024 frames
pub const PS1_BLOCK_SIZE: usize = 8 * 1024; // 8,192 bytes
pub const PS1_TOTAL_BLOCKS: usize = 16;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Ps1BlockState {
    Free,
    InUseFirst,
    InUseMid,
    InUseLast,
    Corrupted,
}

pub struct Ps1MemoryCard {
    data: Box<[u8; PS1_CARD_SIZE]>,
    atomic_file: AtomicFile,
    hot_swap_flag: u8, // 0x08 means card was swapped/unread
}

impl Ps1MemoryCard {
    pub fn new(path: impl AsRef<Path>) -> Self {
        let mut atomic_file = AtomicFile::new(path);
        let mut data = Box::new([0u8; PS1_CARD_SIZE]);

        if atomic_file.exists() {
            if let Some(bytes) = atomic_file.read().ok().filter(|b| b.len() == PS1_CARD_SIZE) {
                data.copy_from_slice(&bytes);
            }
        } else {
            // Format new empty card
            Self::format_raw(&mut data);
            let _ = atomic_file.write_atomic(&data[..]);
        }

        Self {
            data,
            atomic_file,
            hot_swap_flag: 0x08,
        }
    }

    pub fn format_raw(data: &mut [u8; PS1_CARD_SIZE]) {
        data.fill(0);
        // Header frame 0: Magic 'MC'
        data[0] = b'M';
        data[1] = b'C';
        data[127] = Self::calculate_xor_checksum(&data[0..127]);

        // Frames 1-15: Directory entries
        for block in 1..PS1_TOTAL_BLOCKS {
            let offset = block * PS1_FRAME_SIZE;
            // 0xA0 = Free block allocation state
            data[offset] = 0xA0;
            data[offset + 127] = Self::calculate_xor_checksum(&data[offset..offset + 127]);
        }
    }

    pub fn calculate_xor_checksum(frame: &[u8]) -> u8 {
        frame.iter().fold(0u8, |acc, &b| acc ^ b)
    }

    pub fn read_frame(&mut self, frame_index: usize, out: &mut [u8; PS1_FRAME_SIZE]) -> Result<u8, io::Error> {
        if frame_index >= PS1_TOTAL_FRAMES {
            return Err(io::Error::new(io::ErrorKind::InvalidInput, "Frame index out of bounds"));
        }
        let offset = frame_index * PS1_FRAME_SIZE;
        out.copy_from_slice(&self.data[offset..offset + PS1_FRAME_SIZE]);

        // SIO0 status byte: clear hot-swap flag on first read
        let flag = self.hot_swap_flag;
        self.hot_swap_flag = 0x00;
        let checksum = Self::calculate_xor_checksum(&out[0..127]);
        Ok(flag | checksum)
    }

    pub fn write_frame(&mut self, frame_index: usize, frame_data: &[u8; PS1_FRAME_SIZE]) -> Result<(), io::Error> {
        if frame_index >= PS1_TOTAL_FRAMES {
            return Err(io::Error::new(io::ErrorKind::InvalidInput, "Frame index out of bounds"));
        }
        let offset = frame_index * PS1_FRAME_SIZE;
        self.data[offset..offset + PS1_FRAME_SIZE].copy_from_slice(frame_data);
        self.atomic_file.mark_dirty();
        Ok(())
    }

    pub fn flush(&mut self) -> io::Result<()> {
        if self.atomic_file.is_dirty() {
            self.atomic_file.write_atomic(&self.data[..])?;
        }
        Ok(())
    }

    pub fn get_free_blocks_count(&self) -> usize {
        let mut free = 0;
        for block in 1..PS1_TOTAL_BLOCKS {
            let offset = block * PS1_FRAME_SIZE;
            if self.data[offset] == 0xA0 {
                free += 1;
            }
        }
        free
    }

    pub fn format(&mut self) -> io::Result<()> {
        Self::format_raw(&mut self.data);
        self.atomic_file.write_atomic(&self.data[..])
    }
}
