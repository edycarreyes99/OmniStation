use std::fs::File;
use std::io::{Read, Seek, SeekFrom};
use std::path::Path;
use crate::VfsError;

pub struct PspPbpHeader {
    pub magic: [u8; 4],
    pub version: u32,
    pub offset_param_sfo: u32,
    pub offset_icon0_png: u32,
    pub offset_icon1_pmf: u32,
    pub offset_pic0_png: u32,
    pub offset_pic1_png: u32,
    pub offset_snd0_at3: u32,
    pub offset_data_psp: u32,
    pub offset_data_psar: u32,
}

pub struct PspPbpReader {
    pub header: PspPbpHeader,
}

impl PspPbpReader {
    pub fn open(path: &Path) -> Result<Self, VfsError> {
        let mut file = File::open(path)?;
        let mut magic = [0u8; 4];
        file.read_exact(&mut magic)?;
        if &magic != b"\x00PBP" {
            return Err(VfsError::CorruptMedia("Invalid PSP PBP signature".into()));
        }

        let mut buf32 = [0u8; 36];
        file.read_exact(&mut buf32)?;

        let version = u32::from_le_bytes([buf32[0], buf32[1], buf32[2], buf32[3]]);
        let offset_param_sfo = u32::from_le_bytes([buf32[4], buf32[5], buf32[6], buf32[7]]);
        let offset_icon0_png = u32::from_le_bytes([buf32[8], buf32[9], buf32[10], buf32[11]]);
        let offset_icon1_pmf = u32::from_le_bytes([buf32[12], buf32[13], buf32[14], buf32[15]]);
        let offset_pic0_png = u32::from_le_bytes([buf32[16], buf32[17], buf32[18], buf32[19]]);
        let offset_pic1_png = u32::from_le_bytes([buf32[20], buf32[21], buf32[22], buf32[23]]);
        let offset_snd0_at3 = u32::from_le_bytes([buf32[24], buf32[25], buf32[26], buf32[27]]);
        let offset_data_psp = u32::from_le_bytes([buf32[28], buf32[29], buf32[30], buf32[31]]);
        let offset_data_psar = u32::from_le_bytes([buf32[32], buf32[33], buf32[34], buf32[35]]);

        Ok(Self {
            header: PspPbpHeader {
                magic,
                version,
                offset_param_sfo,
                offset_icon0_png,
                offset_icon1_pmf,
                offset_pic0_png,
                offset_pic1_png,
                offset_snd0_at3,
                offset_data_psp,
                offset_data_psar,
            },
        })
    }

    pub fn read_param_sfo_bytes(&self, path: &Path) -> Result<Vec<u8>, VfsError> {
        let mut file = File::open(path)?;
        let start = self.header.offset_param_sfo as u64;
        let end = self.header.offset_icon0_png as u64;
        if end <= start {
            return Err(VfsError::ParamSfoError("Empty PARAM.SFO in PBP".into()));
        }
        let len = (end - start) as usize;
        file.seek(SeekFrom::Start(start))?;
        let mut buf = vec![0u8; len];
        file.read_exact(&mut buf)?;
        Ok(buf)
    }
}
