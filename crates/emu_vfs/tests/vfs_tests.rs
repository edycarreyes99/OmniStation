use emu_vfs::ps3_pkg::PkgInstaller;
use emu_vfs::ps3_pup::PupExtractor;
use emu_vfs::ps3_self::SelfParser;
use emu_vfs::ps3_sfo::ParamSfo;
use emu_vfs::snes_header::{ExpansionChip, SnesHeaderParser, SnesMapMode};
use emu_vfs::{detect_media_type, MediaType};
use std::fs::File;
use std::io::Write;
use tempfile::tempdir;

#[test]
fn test_sfo_parsing() {
    let mut data = vec![
        0x00, 0x50, 0x53, 0x46, 0x01, 0x01, 0x00, 0x00,
        0x24, 0x00, 0x00, 0x00, 0x30, 0x00, 0x00, 0x00,
        0x01, 0x00, 0x00, 0x00,
        // Entry 0: TITLE_ID
        0x00, 0x00, 0x04, 0x02, 0x0A, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ];
    data.extend_from_slice(b"TITLE_ID\x00\x00\x00\x00");
    let mut id_bytes = b"BLUS30443\0".to_vec();
    id_bytes.resize(16, 0);
    data.extend_from_slice(&id_bytes);

    let sfo = ParamSfo::parse(&data).expect("SFO parse failed");
    assert_eq!(sfo.title_id, "BLUS30443");
}

#[test]
fn test_self_parsing() {
    let mut mock_self = b"SCE\x00".to_vec();
    mock_self.extend_from_slice(&[0u8; 128]);
    assert!(SelfParser::is_self(&mock_self));

    let decrypted = SelfParser::decrypt_and_extract(&mock_self).expect("SELF decrypt failed");
    assert_eq!(decrypted.entry_point, 0x10000);
}

#[test]
fn test_pkg_inspect_and_install() {
    let dir = tempdir().unwrap();
    let pkg_path = dir.path().join("game.pkg");
    let hdd_root = dir.path().join("dev_hdd0");

    let mut pkg_data = b"\x7FPKG\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01".to_vec();
    pkg_data.resize(48, 0);
    pkg_data.extend_from_slice(b"UP0001-BLUS30443_00-0000000000000000");
    pkg_data.resize(128, 0);

    let mut file = File::create(&pkg_path).unwrap();
    file.write_all(&pkg_data).unwrap();

    let info = PkgInstaller::inspect(&pkg_path).expect("PKG inspect failed");
    assert_eq!(info.title_id, "BLUS30443");

    let title_id = PkgInstaller::install_pkg(&pkg_path, &hdd_root, None).expect("PKG install failed");
    assert_eq!(title_id, "BLUS30443");
    assert!(hdd_root.join("game/BLUS30443/PARAM.SFO").exists());
}

#[test]
fn test_pup_extraction() {
    let dir = tempdir().unwrap();
    let pup_path = dir.path().join("PS3UPDAT.PUP");
    let flash_dir = dir.path().join("dev_flash");

    let mut pup_data = b"SCEUF\x00\x00\x00".to_vec();
    pup_data.resize(16, 0);
    pup_data.extend_from_slice(&1u64.to_be_bytes()); // 1 file
    pup_data.resize(32, 0);

    // Entry 0: ID=1, Offset=64, Size=16
    pup_data.extend_from_slice(&1u64.to_be_bytes());
    pup_data.extend_from_slice(&64u64.to_be_bytes());
    pup_data.extend_from_slice(&16u64.to_be_bytes());
    pup_data.resize(64, 0);
    pup_data.extend_from_slice(b"1234567890ABCDEF");

    let mut file = File::create(&pup_path).unwrap();
    file.write_all(&pup_data).unwrap();

    let count = PupExtractor::extract(&pup_path, &flash_dir).expect("PUP extraction failed");
    assert_eq!(count, 1);
    assert!(flash_dir.join("module_0001.sprx").exists());
}

#[test]
fn test_snes_header_parse() {
    let dir = tempdir().unwrap();
    let snes_path = dir.path().join("game.sfc");

    let mut rom = vec![0u8; 0x8000];
    // LoROM Header at 0x7FC0
    let title = b"SUPER TEST GAME      ";
    rom[0x7FC0..0x7FD5].copy_from_slice(title);
    rom[0x7FD5] = 0x20; // LoROM
    rom[0x7FD6] = 0x14; // Super FX chip
    rom[0x7FD7] = 0x09; // 512 KB
    rom[0x7FD8] = 0x03; // 8 KB SRAM
    rom[0x7FDC] = 0x12;
    rom[0x7FDD] = 0x34;
    rom[0x7FDE] = 0xED;
    rom[0x7FDF] = 0xCB; // Complement

    let mut file = File::create(&snes_path).unwrap();
    file.write_all(&rom).unwrap();

    let info = SnesHeaderParser::parse(&snes_path).expect("SNES parse failed");
    assert_eq!(info.map_mode, SnesMapMode::LoRom);
    assert_eq!(info.chip, ExpansionChip::SuperFx);
    assert!(info.checksum_valid);
}

#[test]
fn test_media_detection() {
    let dir = tempdir().unwrap();
    let sfc_file = dir.path().join("game.sfc");
    File::create(&sfc_file).unwrap();
    assert_eq!(detect_media_type(&sfc_file).unwrap(), MediaType::SnesRom);

    let pkg_file = dir.path().join("app.pkg");
    File::create(&pkg_file).unwrap();
    assert_eq!(detect_media_type(&pkg_file).unwrap(), MediaType::Ps3Pkg);

    // Test .msc format for ZSNES
    let msc_file = dir.path().join("game.msc");
    File::create(&msc_file).unwrap();
    assert_eq!(detect_media_type(&msc_file).unwrap(), MediaType::SnesRom);

    // Test .zip format containing SNES ROM
    let zip_file = dir.path().join("archive.zip");
    let mut zip_header = b"PK\x03\x04\x14\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00".to_vec();
    let inner_name = b"game.smc";
    zip_header.extend_from_slice(&(inner_name.len() as u16).to_le_bytes()); // name length
    zip_header.extend_from_slice(&0u16.to_le_bytes()); // extra length
    zip_header.extend_from_slice(inner_name);
    let mut f = File::create(&zip_file).unwrap();
    f.write_all(&zip_header).unwrap();
    assert_eq!(detect_media_type(&zip_file).unwrap(), MediaType::SnesRom);
}

