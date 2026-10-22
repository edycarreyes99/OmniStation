use crate::VfsError;
use std::collections::HashMap;

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum SfoValue {
    Utf8(String),
    Int32(u32),
    Binary(Vec<u8>),
}

#[derive(Debug, Clone)]
pub struct ParamSfo {
    pub title_id: String,
    pub title: String,
    pub category: String,
    pub app_version: String,
    pub min_firmware: String,
    pub entries: HashMap<String, SfoValue>,
}

impl ParamSfo {
    pub const PSF_MAGIC: &'static [u8; 4] = b"\x00PSF";

    pub fn parse(data: &[u8]) -> Result<Self, VfsError> {
        if data.len() < 20 {
            return Err(VfsError::ParamSfoError("SFO data too small".into()));
        }

        if &data[0..4] != Self::PSF_MAGIC {
            return Err(VfsError::ParamSfoError("Invalid SFO magic header".into()));
        }

        let key_table_start = u32::from_le_bytes(data[8..12].try_into().unwrap()) as usize;
        let data_table_start = u32::from_le_bytes(data[12..16].try_into().unwrap()) as usize;
        let num_entries = u32::from_le_bytes(data[16..20].try_into().unwrap()) as usize;

        if data.len() < 20 + num_entries * 16 {
            return Err(VfsError::ParamSfoError("SFO index table truncated".into()));
        }

        let mut entries = HashMap::new();

        for i in 0..num_entries {
            let offset = 20 + i * 16;
            let key_offset = u16::from_le_bytes(data[offset..offset + 2].try_into().unwrap()) as usize;
            let param_format = u16::from_le_bytes(data[offset + 2..offset + 4].try_into().unwrap());
            let param_len = u32::from_le_bytes(data[offset + 4..offset + 8].try_into().unwrap()) as usize;
            let data_offset = u32::from_le_bytes(data[offset + 12..offset + 16].try_into().unwrap()) as usize;

            let key_pos = key_table_start + key_offset;
            if key_pos >= data.len() {
                continue;
            }

            // Find null terminator
            let mut key_end = key_pos;
            while key_end < data.len() && data[key_end] != 0 {
                key_end += 1;
            }
            let key = String::from_utf8_lossy(&data[key_pos..key_end]).to_string();

            let val_pos = data_table_start + data_offset;
            if val_pos + param_len > data.len() {
                continue;
            }
            let val_bytes = &data[val_pos..val_pos + param_len];

            let value = match param_format {
                0x0004 | 0x0204 => {
                    // UTF-8 string null terminated
                    let clean = val_bytes.strip_suffix(b"\0").unwrap_or(val_bytes);
                    SfoValue::Utf8(String::from_utf8_lossy(clean).to_string())
                }
                0x0404 => {
                    // Integer 32-bit
                    if param_len >= 4 {
                        let int_val = u32::from_le_bytes(val_bytes[0..4].try_into().unwrap());
                        SfoValue::Int32(int_val)
                    } else {
                        SfoValue::Binary(val_bytes.to_vec())
                    }
                }
                _ => SfoValue::Binary(val_bytes.to_vec()),
            };

            entries.insert(key, value);
        }

        let title_id = match entries.get("TITLE_ID") {
            Some(SfoValue::Utf8(s)) => s.clone(),
            _ => "UNKNOWN00".into(),
        };

        let title = match entries.get("TITLE") {
            Some(SfoValue::Utf8(s)) => s.clone(),
            _ => "Unknown PS3 Title".into(),
        };

        let category = match entries.get("CATEGORY") {
            Some(SfoValue::Utf8(s)) => s.clone(),
            _ => "DG".into(),
        };

        let app_version = match entries.get("APP_VER") {
            Some(SfoValue::Utf8(s)) => s.clone(),
            _ => "01.00".into(),
        };

        let min_firmware = match entries.get("PS3_SYSTEM_VER") {
            Some(SfoValue::Utf8(s)) => s.clone(),
            _ => "03.5500".into(),
        };

        Ok(Self {
            title_id,
            title,
            category,
            app_version,
            min_firmware,
            entries,
        })
    }
}
