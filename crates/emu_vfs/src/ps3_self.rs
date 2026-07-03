use crate::VfsError;

#[derive(Debug, Clone)]
pub struct SelfSection {
    pub offset: u64,
    pub size: u64,
    pub compressed: bool,
    pub encrypted: bool,
}

#[derive(Debug, Clone)]
pub struct DecryptedElf {
    pub entry_point: u64,
    pub segments: Vec<(u64, Vec<u8>)>, // (Virtual Address, Segment Data)
}

pub struct SelfParser;

impl SelfParser {
    pub const SCE_MAGIC: &'static [u8; 4] = b"SCE\x00";

    pub fn is_self(data: &[u8]) -> bool {
        data.len() >= 4 && &data[0..4] == Self::SCE_MAGIC
    }

    pub fn decrypt_and_extract(data: &[u8]) -> Result<DecryptedElf, VfsError> {
        if !Self::is_self(data) {
            // Already raw ELF64?
            if data.len() >= 4 && &data[0..4] == b"\x7FELF" {
                return Self::extract_raw_elf(data);
            }
            return Err(VfsError::SelfDecryptionError("Not a valid SCE SELF header".into()));
        }

        if data.len() < 64 {
            return Err(VfsError::SelfDecryptionError("Header truncated".into()));
        }

        let _header_type = u32::from_be_bytes(data[4..8].try_into().unwrap());
        let _app_info_offset = u64::from_be_bytes(data[8..16].try_into().unwrap()) as usize;
        let elf_offset = u64::from_be_bytes(data[16..24].try_into().unwrap()) as usize;
        let _phdr_offset = u64::from_be_bytes(data[24..32].try_into().unwrap()) as usize;
        let _shdr_offset = u64::from_be_bytes(data[32..40].try_into().unwrap()) as usize;

        // If self payload has embedded ELF header
        if elf_offset < data.len() && data.len() >= elf_offset + 64 {
            let elf_header = &data[elf_offset..elf_offset + 64];
            if &elf_header[0..4] == b"\x7FELF" {
                return Self::extract_raw_elf(&data[elf_offset..]);
            }
        }

        // Raw decrypted SELF payload extraction for homebrew and unpacked executables
        let entry_point = 0x10000u64;
        let mut segments = Vec::new();
        // Extract main code payload
        let payload_start = std::cmp::min(128, data.len());
        let payload = data[payload_start..].to_vec();
        segments.push((entry_point, payload));

        Ok(DecryptedElf {
            entry_point,
            segments,
        })
    }

    fn extract_raw_elf(data: &[u8]) -> Result<DecryptedElf, VfsError> {
        if data.len() < 64 {
            return Err(VfsError::SelfDecryptionError("ELF64 header truncated".into()));
        }
        // ELF64 Big Endian for PowerPC
        let entry_point = u64::from_be_bytes(data[24..32].try_into().unwrap());
        let ph_offset = u64::from_be_bytes(data[32..40].try_into().unwrap()) as usize;
        let ph_num = u16::from_be_bytes(data[56..58].try_into().unwrap()) as usize;
        let ph_size = u16::from_be_bytes(data[54..56].try_into().unwrap()) as usize;

        let mut segments = Vec::new();
        for i in 0..ph_num {
            let offset = ph_offset + i * ph_size;
            if offset + 56 > data.len() {
                break;
            }
            let p_type = u32::from_be_bytes(data[offset..offset + 4].try_into().unwrap());
            if p_type == 1 {
                // PT_LOAD
                let p_offset = u64::from_be_bytes(data[offset + 8..offset + 16].try_into().unwrap()) as usize;
                let p_vaddr = u64::from_be_bytes(data[offset + 16..offset + 24].try_into().unwrap());
                let p_filesz = u64::from_be_bytes(data[offset + 32..offset + 40].try_into().unwrap()) as usize;

                if p_offset + p_filesz <= data.len() {
                    segments.push((p_vaddr, data[p_offset..p_offset + p_filesz].to_vec()));
                }
            }
        }

        Ok(DecryptedElf {
            entry_point,
            segments,
        })
    }
}
