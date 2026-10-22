use emu_storage::ps1_card::{Ps1MemoryCard, PS1_FRAME_SIZE};
use emu_storage::ps2_card::{Ps2MemoryCard, PS2_PAGE_DATA_SIZE};
use emu_storage::ps3_hdd::Ps3VirtualHdd;
use emu_storage::ps3_trophy::Ps3TrophyManager;
use emu_storage::save_state::SaveStateManager;
use emu_storage::snes_sram::SnesSram;
use tempfile::tempdir;

#[test]
fn test_ps1_memory_card() {
    let dir = tempdir().unwrap();
    let card_path = dir.path().join("slot1.mcr");

    let mut card = Ps1MemoryCard::new(&card_path);
    assert_eq!(card.get_free_blocks_count(), 15);

    let mut frame = [0u8; PS1_FRAME_SIZE];
    frame[0] = 0xAA;
    frame[127] = Ps1MemoryCard::calculate_xor_checksum(&frame[0..127]);

    card.write_frame(1, &frame).unwrap();
    card.flush().unwrap();

    let mut read_frame = [0u8; PS1_FRAME_SIZE];
    let _status = card.read_frame(1, &mut read_frame).unwrap();
    assert_eq!(read_frame[0], 0xAA);
    assert_eq!(read_frame[127], frame[127]);

    // Format card
    card.format().unwrap();
    assert_eq!(card.get_free_blocks_count(), 15);
}

#[test]
fn test_ps2_memory_card() {
    let dir = tempdir().unwrap();
    let card_path = dir.path().join("slot1.ps2");

    let mut card = Ps2MemoryCard::new(&card_path);
    let mut page = [0u8; PS2_PAGE_DATA_SIZE];
    page[0] = 0x55;
    page[511] = 0xEE;

    card.write_page(10, &page).unwrap();
    card.flush().unwrap();

    let mut read_page = [0u8; PS2_PAGE_DATA_SIZE];
    card.read_page(10, &mut read_page).unwrap();
    assert_eq!(read_page[0], 0x55);
    assert_eq!(read_page[511], 0xEE);

    let challenge = [1, 2, 3, 4, 5, 6, 7, 8];
    let response = card.authenticate_magicgate(&challenge);
    assert_eq!(response[0], 1 ^ 0x5A);
}

#[test]
fn test_ps3_hdd_and_pfd_signing() {
    let dir = tempdir().unwrap();
    let hdd = Ps3VirtualHdd::new(dir.path()).unwrap();

    let save_data = b"PLAYER_PROGRESS_DATA_LEVEL_99";
    hdd.write_save_entry("BLES00001_SAVE", "SAVE.DAT", save_data).unwrap();

    let read_back = hdd.read_save_entry("BLES00001_SAVE", "SAVE.DAT").unwrap();
    assert_eq!(read_back, save_data);

    let save_dir = hdd.get_savedata_path("BLES00001_SAVE");
    assert!(hdd.verify_pfd(&save_dir).unwrap());
}

#[test]
fn test_ps3_trophy_manager() {
    let dir = tempdir().unwrap();
    let mut trophies = Ps3TrophyManager::new(dir.path(), "NPWR00001_00").unwrap();

    assert_eq!(trophies.total_unlocked(), 0);
    assert!(trophies.unlock_trophy(1).unwrap());
    assert!(!trophies.unlock_trophy(1).unwrap()); // Duplicate unlock returns false
    assert!(trophies.is_unlocked(1));
    assert_eq!(trophies.total_unlocked(), 1);
}

#[test]
fn test_snes_sram() {
    let dir = tempdir().unwrap();
    let sram_path = dir.path().join("game.srm");

    let mut sram = SnesSram::new(&sram_path, 8192);
    sram.write_byte(0x00, 0x42);
    sram.write_byte(0xFF, 0x99);
    sram.flush().unwrap();

    let loaded_sram = SnesSram::new(&sram_path, 8192);
    assert_eq!(loaded_sram.read_byte(0x00), 0x42);
    assert_eq!(loaded_sram.read_byte(0xFF), 0x99);
}

#[test]
fn test_save_state_zstd() {
    let dir = tempdir().unwrap();
    let state_path = dir.path().join("slot0.state");

    let uncompressed = vec![0xABu8; 1024 * 1024]; // 1 MB of memory
    SaveStateManager::save(&state_path, 4, &uncompressed).unwrap(); // Platform 4 = PS3

    let restored = SaveStateManager::load(&state_path, 4).unwrap();
    assert_eq!(restored.len(), uncompressed.len());
    assert_eq!(restored[0], 0xAB);
    assert_eq!(restored[1024 * 1024 - 1], 0xAB);
}
