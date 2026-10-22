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

#[test]
fn test_psp_memory_stick() {
    let dir = tempdir().unwrap();
    let ms = emu_storage::psp_memstick::PspMemoryStick::new(dir.path()).unwrap();

    let save_bytes = b"PSP_SAVEDATA_CHUNK";
    ms.write_save_data("ULES00001", "DATA.BIN", save_bytes).unwrap();
    assert!(ms.save_exists("ULES00001"));

    let read_back = ms.read_save_data("ULES00001", "DATA.BIN").unwrap();
    assert_eq!(read_back, save_bytes);
}

#[test]
fn test_psvita_memory_card() {
    let dir = tempdir().unwrap();
    let card = emu_storage::psvita_card::PsVitaMemoryCard::new(dir.path()).unwrap();

    let chunk = b"VITA_SLOT_0_PAYLOAD";
    card.write_save_chunk("PCSF00001", "savedata.bin", chunk).unwrap();

    let read = card.read_save_chunk("PCSF00001", "savedata.bin").unwrap();
    assert_eq!(read, chunk);
}

#[test]
fn test_wii_nand_storage() {
    let dir = tempdir().unwrap();
    let nand = emu_storage::wii_nand::WiiNandStorage::new(dir.path()).unwrap();

    let banner = b"WII_BANNER_RGB5A3";
    nand.write_banner_bin("RSBE01", banner).unwrap();

    let save = b"WII_SAVE_DATA_BLOCK";
    nand.write_data_bin("RSBE01", save).unwrap();

    let read_save = nand.read_data_bin("RSBE01").unwrap();
    assert_eq!(read_save, save);
}

#[test]
fn test_wiiu_mlc_storage() {
    let dir = tempdir().unwrap();
    let mlc = emu_storage::wiiu_mlc::WiiUMlcStorage::new(dir.path()).unwrap();

    let meta = "<xml><title>Super Smash Bros. for Wii U</title></xml>";
    mlc.write_meta_xml("10145000", meta).unwrap();

    let user_save = b"WIIU_USER_PROFILE_DATA";
    mlc.write_save_file("10145000", "user.dat", user_save).unwrap();

    let read_user = mlc.read_save_file("10145000", "user.dat").unwrap();
    assert_eq!(read_user, user_save);
}

