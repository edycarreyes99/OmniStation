use serde::{Deserialize, Serialize};
use std::collections::HashSet;
use std::fs::{self, File};
use std::io::{self, Write};
use std::path::{Path, PathBuf};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum TrophyGrade {
    Bronze,
    Silver,
    Gold,
    Platinum,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TrophyInfo {
    pub id: u32,
    pub grade: TrophyGrade,
    pub name: String,
    pub description: String,
    pub unlocked: bool,
    pub timestamp: u64,
}

pub struct Ps3TrophyManager {
    trophy_dir: PathBuf,
    unlocked_ids: HashSet<u32>,
}

impl Ps3TrophyManager {
    pub fn new(root_dir: impl AsRef<Path>, np_comm_id: &str) -> io::Result<Self> {
        let trophy_dir = root_dir
            .as_ref()
            .join("home/00000001/trophy")
            .join(np_comm_id);
        fs::create_dir_all(&trophy_dir)?;

        let mut manager = Self {
            trophy_dir,
            unlocked_ids: HashSet::new(),
        };
        manager.load_trophies()?;
        Ok(manager)
    }

    fn state_file(&self) -> PathBuf {
        self.trophy_dir.join("TROPUSR.DAT")
    }

    fn load_trophies(&mut self) -> io::Result<()> {
        let path = self.state_file();
        if path.exists() {
            let data = fs::read(path)?;
            if let Ok(unlocked) = serde_json::from_slice::<HashSet<u32>>(&data) {
                self.unlocked_ids = unlocked;
            }
        }
        Ok(())
    }

    pub fn unlock_trophy(&mut self, trophy_id: u32) -> io::Result<bool> {
        if self.unlocked_ids.contains(&trophy_id) {
            return Ok(false); // Already unlocked
        }

        self.unlocked_ids.insert(trophy_id);
        let serialized = serde_json::to_vec(&self.unlocked_ids)
            .map_err(io::Error::other)?;

        let mut f = File::create(self.state_file())?;
        f.write_all(&serialized)?;
        f.sync_all()?;
        Ok(true)
    }

    pub fn is_unlocked(&self, trophy_id: u32) -> bool {
        self.unlocked_ids.contains(&trophy_id)
    }

    pub fn total_unlocked(&self) -> usize {
        self.unlocked_ids.len()
    }
}
