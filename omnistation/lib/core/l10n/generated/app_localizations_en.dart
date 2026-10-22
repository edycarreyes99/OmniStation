// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'OmniStation';

  @override
  String get tagline => 'High-Performance Multi-System Emulator';

  @override
  String get navLibrary => 'Library';

  @override
  String get navStorage => 'Storage';

  @override
  String get navTrophies => 'Trophies';

  @override
  String get navSettings => 'Settings';

  @override
  String get platformSnes => 'Super Nintendo';

  @override
  String get platformPs1 => 'PlayStation 1';

  @override
  String get platformPs2 => 'PlayStation 2';

  @override
  String get platformPs3 => 'PlayStation 3';

  @override
  String get platformPsp => 'PlayStation Portable';

  @override
  String get platformPsVita => 'PlayStation Vita';

  @override
  String get platformWii => 'Nintendo Wii';

  @override
  String get platformWiiU => 'Nintendo Wii U';

  @override
  String get statusReady => 'Ready';

  @override
  String get statusRunning => 'Running';

  @override
  String get statusPaused => 'Paused';

  @override
  String get statusStopped => 'Stopped';

  @override
  String get statusCompilingShaders => 'Compiling Shaders...';

  @override
  String get statusBootingKernel => 'Booting Kernel...';

  @override
  String get statusLoadingDisc => 'Loading Optical Disc...';

  @override
  String get telemetryFps => 'FPS';

  @override
  String get telemetryFrameTime => 'Frame Time';

  @override
  String get telemetryPpu => 'PPU';

  @override
  String get telemetrySpu => 'SPU';

  @override
  String get telemetryEe => 'EE';

  @override
  String get telemetryGs => 'GS';

  @override
  String get telemetryRsx => 'RSX';

  @override
  String get telemetryAudioDrc => 'DRC';

  @override
  String get actionPlay => 'Play';

  @override
  String get actionPause => 'Pause';

  @override
  String get actionResume => 'Resume';

  @override
  String get actionStop => 'Stop';

  @override
  String get actionRestart => 'Restart';

  @override
  String get actionLoadState => 'Load State';

  @override
  String get actionSaveState => 'Save State';

  @override
  String get actionQuickMenu => 'Quick Menu';

  @override
  String get actionInstallPkg => 'Install PKG/PUP';

  @override
  String get actionInsertDisc => 'Insert Disc';

  @override
  String get actionEjectDisc => 'Eject Disc';

  @override
  String get storageMemoryCard => 'Memory Card';

  @override
  String get storageMemoryCardSlot1 => 'Memory Card Slot 1';

  @override
  String get storageMemoryCardSlot2 => 'Memory Card Slot 2';

  @override
  String get storagePs3Hdd => 'PS3 Virtual HDD';

  @override
  String storageBlocksFree(int count) {
    return '$count blocks free';
  }

  @override
  String get storageFormat => 'Format Card';

  @override
  String get storageFormatConfirm =>
      'Are you sure you want to format this Memory Card? All save data will be permanently erased.';

  @override
  String get storageFormatSuccess => 'Memory Card formatted successfully.';

  @override
  String get trophyUnlocked => 'Trophy Unlocked!';

  @override
  String get trophyBronze => 'Bronze';

  @override
  String get trophySilver => 'Silver';

  @override
  String get trophyGold => 'Gold';

  @override
  String get trophyPlatinum => 'Platinum';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsGraphics => 'Graphics';

  @override
  String get settingsAudio => 'Audio';

  @override
  String get settingsInput => 'Input & Controllers';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light Mode';

  @override
  String get settingsThemeDark => 'Dark Mode';

  @override
  String get settingsThemeSystem => 'System Default';

  @override
  String get settingsInternalResolution => 'Internal Resolution Scaling';

  @override
  String get settingsShaderPreset => 'Post-Processing Filter';

  @override
  String get settingsShaderNone => 'Bilinear';

  @override
  String get settingsShaderCrt => 'CRT Royale';

  @override
  String get settingsShaderScanlines => 'Scanlines';

  @override
  String get errorTitle => 'Emulation Error';

  @override
  String get errorUnknown => 'An unexpected error occurred during emulation.';

  @override
  String get errorDiscRead =>
      'Failed to read optical disc image. The file may be corrupt or inaccessible.';

  @override
  String get errorUdfFs => 'Failed to parse Blu-ray UDF 2.50 file system.';

  @override
  String get errorIsoDecryption =>
      'Encrypted PS3 disc detected. Missing or invalid decryption key (.ird / .dkey).';

  @override
  String get errorParamSfo => 'Failed to read or parse PARAM.SFO metadata.';

  @override
  String get errorSelfDecryption =>
      'Failed to decrypt SELF/SPRX binary. SCE/NPDRM signature check failed.';

  @override
  String get errorPkgRapMissing =>
      'Missing .rap license file for installed PKG package.';

  @override
  String get errorFirmwareMissing =>
      'Required firmware or BIOS file was not found. Please install the system software.';

  @override
  String get errorMemoryCardCorrupt =>
      'Memory card image is corrupted or failed checksum verification.';

  @override
  String get errorPs3SaveDataSignature =>
      'PS3 save data verification failed (corrupted PARAM.PFD signature).';

  @override
  String get errorSaveStateVersion =>
      'Save state version is incompatible with this core build.';

  @override
  String get errorAudioInit => 'Failed to initialize low-latency audio sink.';

  @override
  String get errorGpuInit =>
      'Hardware GPU renderer failed to initialize. Check Vulkan/Metal compatibility.';

  @override
  String get errorJitAllocation =>
      'Failed to allocate executable JIT code cache memory.';

  @override
  String get actionOk => 'OK';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get filterAll => 'All Consoles';

  @override
  String get actionHideHud => 'Hide HUD';

  @override
  String get actionShowHud => 'Show HUD';

  @override
  String get actionSimulateTrophy => 'Simulate Trophy Unlock';

  @override
  String saveStateSuccess(int slot) {
    return 'Save state completed successfully (Slot $slot).';
  }

  @override
  String loadStateSuccess(int slot) {
    return 'Load state restored successfully (Slot $slot).';
  }

  @override
  String get trophyGrandMaster => 'OmniStation Grand Master';

  @override
  String unitMilliseconds(String value) {
    return '$value ms';
  }

  @override
  String percentFormat(int value) {
    return '$value%';
  }

  @override
  String get statusRtlActive => 'RTL Active';

  @override
  String get tagRtl => '(RTL)';

  @override
  String get settingsGraphicsScaleDesc =>
      'Vulkan 1.3 / Metal 3 Hardware Scaler';

  @override
  String get settingsResNative => '1x Native';

  @override
  String get settingsRes1440p => '2x (1440p Quad HD)';

  @override
  String get settingsRes4k => '4x (4K Ultra HD)';

  @override
  String get settingsRes8k => '8x (8K Extreme)';

  @override
  String get settingsShaderDesc => 'Impeller Real-Time Shader Pipeline';

  @override
  String get storagePs1Capacity => 'PlayStation 1 (128 KB)';

  @override
  String get storagePs2Capacity => 'PlayStation 2 (8 MB)';

  @override
  String get storagePfdValid => 'PARAM.PFD Valid';

  @override
  String get storagePs3HddPath => 'dev_hdd0/home/00000001/savedata';

  @override
  String storagePs3HddUsage(String used, String total) {
    return '$used GB / $total GB';
  }

  @override
  String get trophyPioneerTitle => 'OmniStation Pioneer';

  @override
  String get trophyPioneerDesc =>
      'Booted the OmniStation multi-system emulator for the first time.';

  @override
  String get trophyVeteranTitle => 'Hardware Veteran';

  @override
  String get trophyVeteranDesc =>
      'Configured Metal 3 and Vulkan 1.3 zero-copy texture pipelines.';

  @override
  String get trophyCellMasterTitle => 'Master of Cell Broadband Engine';

  @override
  String get trophyCellMasterDesc =>
      'Ran PowerPC PPE and 6 SPU worker threads concurrently with 0 jitter.';

  @override
  String get trophyArchitectTitle => 'Platinum Architect';

  @override
  String get trophyArchitectDesc =>
      'Achieved 100% test coverage across C++23, Rust, and Flutter 3.x.';

  @override
  String get btnSelect => 'SELECT';

  @override
  String get btnStart => 'START';

  @override
  String get btnL1 => 'L1';

  @override
  String get btnL2 => 'L2';

  @override
  String get btnR1 => 'R1';

  @override
  String get btnR2 => 'R2';

  @override
  String get errorPkgMissingRapSim =>
      'EP0001-BLES00001_00.rap not found in exdata';

  @override
  String get defaultGameTitle => 'OmniStation Game';

  @override
  String get actionImportGame => 'Import Game';

  @override
  String get actionDeleteGame => 'Delete Game';

  @override
  String get dialogDeleteGameConfirm =>
      'Are you sure you want to delete this game from your library?';

  @override
  String msgGameImportSuccess(String title) {
    return 'Game imported successfully: $title';
  }

  @override
  String msgGameImportFailed(String error) {
    return 'Failed to import game: $error';
  }

  @override
  String get emptyLibraryTitle => 'No Games Installed';

  @override
  String get emptyLibraryDesc =>
      'Import ROMs or disc images (.smc, .sfc, .msc, .iso, .zip, .pkg, .bin, .pbp, .cso, .vpk, .wbfs, .rvz, .wud, .rpx) to begin playing.';

  @override
  String get storageTotalAppSpace => 'Total Storage Used';

  @override
  String get storageGamesSpace => 'Installed Games';

  @override
  String get storageSavesSpace => 'Save States & SRAM';

  @override
  String get storageCardsSpace => 'Virtual Memory Cards';

  @override
  String get storageFreeSpace => 'Device Free Space';

  @override
  String get storageClearCache => 'Clear Cache';

  @override
  String get storageClearCacheSuccess => 'Cache cleared successfully.';

  @override
  String get emptyTrophiesTitle => 'No Trophies Earned';

  @override
  String get emptyTrophiesDesc =>
      'Play games and complete in-game milestones to earn trophies.';

  @override
  String get actionScanDirectory => 'Scan Directory';

  @override
  String unitGigabytes(String value) {
    return '$value GB';
  }

  @override
  String unitMegabytes(String value) {
    return '$value MB';
  }

  @override
  String unitKilobytes(String value) {
    return '$value KB';
  }
}
