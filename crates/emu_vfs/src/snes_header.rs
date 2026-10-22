use crate::VfsError;
use std::fs::File;
use std::io::Read;
use std::path::Path;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SnesMapMode {
    LoRom,
    HiRom,
    ExHiRom,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ExpansionChip {
    None,
    SuperFx,
    Sa1,
    Dsp1,
    Dsp2,
    Cx4,
}

#[derive(Debug, Clone)]
pub struct SnesCartridgeInfo {
    pub title: String,
    pub map_mode: SnesMapMode,
    pub chip: ExpansionChip,
    pub rom_size_bytes: usize,
    pub sram_size_bytes: usize,
    pub checksum_valid: bool,
}

pub struct SnesHeaderParser;

impl SnesHeaderParser {
    pub fn parse(path: &Path) -> Result<SnesCartridgeInfo, VfsError> {
        let mut file = File::open(path)?;
        let mut data = Vec::new();
        file.read_to_end(&mut data)?;

        // Skip 512-byte copier header if present
        let rom_data = if (data.len() % 1024) == 512 {
            &data[512..]
        } else {
            &data[..]
        };

        if rom_data.len() < 0x8000 {
            return Err(VfsError::CorruptMedia("SNES ROM too small".into()));
        }

        // Check LoROM (0x7FC0) vs HiROM (0xFFC0)
        let (offset, mode) = if rom_data.len() >= 0x10000 && Self::score_header(&rom_data[0xFFC0..]) > Self::score_header(&rom_data[0x7FC0..]) {
            (0xFFC0, SnesMapMode::HiRom)
        } else {
            (0x7FC0, SnesMapMode::LoRom)
        };

        let header = &rom_data[offset..offset + 64];
        let title = String::from_utf8_lossy(&header[0..21]).trim().to_string();
        let map_byte = header[21];
        let rom_type = header[22];
        let rom_size_exp = header[23];
        let ram_size_exp = header[24];

        let complement = u16::from_le_bytes(header[28..30].try_into().unwrap());
        let checksum = u16::from_le_bytes(header[30..32].try_into().unwrap());
        let checksum_valid = (checksum ^ complement) == 0xFFFF;

        let rom_size_bytes = 1024 << rom_size_exp;
        let sram_size_bytes = if ram_size_exp > 0 { 1024 << ram_size_exp } else { 0 };

        let chip = match rom_type {
            0x13..=0x15 => ExpansionChip::SuperFx,
            0x34..=0x35 => ExpansionChip::Sa1,
            0x03 | 0x05 => {
                if map_byte == 0x20 || map_byte == 0x21 {
                    ExpansionChip::Dsp1
                } else {
                    ExpansionChip::None
                }
            }
            0xF6 => ExpansionChip::Cx4,
            _ => ExpansionChip::None,
        };

        Ok(SnesCartridgeInfo {
            title,
            map_mode: mode,
            chip,
            rom_size_bytes,
            sram_size_bytes,
            checksum_valid,
        })
    }

    fn score_header(header: &[u8]) -> i32 {
        if header.len() < 32 {
            return -100;
        }
        let complement = u16::from_le_bytes(header[28..30].try_into().unwrap_or([0, 0]));
        let checksum = u16::from_le_bytes(header[30..32].try_into().unwrap_or([0, 0]));
        let mut score = 0;
        if (checksum ^ complement) == 0xFFFF {
            score += 10;
        }
        if header[20] == 0x33 {
            score += 5;
        }
        score
    }
}
