// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'OmniStation';

  @override
  String get tagline => 'Emulator Multi-Sistem Performa Tinggi';

  @override
  String get navLibrary => 'Pustaka';

  @override
  String get navStorage => 'Penyimpanan';

  @override
  String get navTrophies => 'Piala';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get platformSnes => 'Super Nintendo';

  @override
  String get platformPs1 => 'PlayStation 1';

  @override
  String get platformPs2 => 'PlayStation 2';

  @override
  String get platformPs3 => 'PlayStation 3';

  @override
  String get statusReady => 'Siap';

  @override
  String get statusRunning => 'Berjalan';

  @override
  String get statusPaused => 'Dijeda';

  @override
  String get statusStopped => 'Berhenti';

  @override
  String get statusCompilingShaders => 'Mengompilasi Shader...';

  @override
  String get statusBootingKernel => 'Mem-boot Kernel...';

  @override
  String get statusLoadingDisc => 'Memuat Cakram Optik...';

  @override
  String get telemetryFps => 'FPS';

  @override
  String get telemetryFrameTime => 'Waktu Bingkai';

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
  String get actionPlay => 'Mainkan';

  @override
  String get actionPause => 'Jeda';

  @override
  String get actionResume => 'Lanjutkan';

  @override
  String get actionStop => 'Berhenti';

  @override
  String get actionRestart => 'Mulai Ulang';

  @override
  String get actionLoadState => 'Muat Status';

  @override
  String get actionSaveState => 'Simpan Status';

  @override
  String get actionQuickMenu => 'Menu Cepat';

  @override
  String get actionInstallPkg => 'Pasang PKG/PUP';

  @override
  String get actionInsertDisc => 'Masukkan Cakram';

  @override
  String get actionEjectDisc => 'Keluarkan Cakram';

  @override
  String get storageMemoryCard => 'Kartu Memori';

  @override
  String get storageMemoryCardSlot1 => 'Slot Kartu Memori 1';

  @override
  String get storageMemoryCardSlot2 => 'Slot Kartu Memori 2';

  @override
  String get storagePs3Hdd => 'HDD Virtual PS3';

  @override
  String storageBlocksFree(int count) {
    return '$count blok kosong';
  }

  @override
  String get storageFormat => 'Format Kartu';

  @override
  String get storageFormatConfirm =>
      'Apakah Anda yakin ingin memformat Kartu Memori ini? Semua data penyimpanan akan dihapus secara permanen.';

  @override
  String get storageFormatSuccess => 'Kartu Memori berhasil diformat.';

  @override
  String get trophyUnlocked => 'Piala Terbuka!';

  @override
  String get trophyBronze => 'Perunggu';

  @override
  String get trophySilver => 'Perak';

  @override
  String get trophyGold => 'Emas';

  @override
  String get trophyPlatinum => 'Platina';

  @override
  String get settingsGeneral => 'Umum';

  @override
  String get settingsGraphics => 'Grafis';

  @override
  String get settingsAudio => 'Audio';

  @override
  String get settingsInput => 'Input & Pengontrol';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeLight => 'Mode Terang';

  @override
  String get settingsThemeDark => 'Mode Gelap';

  @override
  String get settingsThemeSystem => 'Bawaan Sistem';

  @override
  String get settingsInternalResolution => 'Skala Resolusi Internal';

  @override
  String get settingsShaderPreset => 'Filter Pasca-Pemrosesan';

  @override
  String get settingsShaderNone => 'Bilinear';

  @override
  String get settingsShaderCrt => 'CRT Royale';

  @override
  String get settingsShaderScanlines => 'Scanlines';

  @override
  String get errorTitle => 'Kesalahan Emulasi';

  @override
  String get errorUnknown => 'Terjadi kesalahan tak terduga selama emulasi.';

  @override
  String get errorDiscRead =>
      'Gagal membaca citra cakram optik. Berkas mungkin rusak atau tidak dapat diakses.';

  @override
  String get errorUdfFs => 'Gagal mengurai sistem berkas Blu-ray UDF 2.50.';

  @override
  String get errorIsoDecryption =>
      'Cakram PS3 terenkripsi terdeteksi. Kunci dekripsi (.ird / .dkey) hilang atau tidak valid.';

  @override
  String get errorParamSfo => 'Gagal membaca atau mengurai metadata PARAM.SFO.';

  @override
  String get errorSelfDecryption =>
      'Gagal mendekripsi biner SELF/SPRX. Pemeriksaan tanda tangan SCE/NPDRM gagal.';

  @override
  String get errorPkgRapMissing =>
      'Berkas lisensi .rap hilang untuk paket PKG yang dipasang.';

  @override
  String get errorFirmwareMissing =>
      'Berkas firmware atau BIOS yang diperlukan tidak ditemukan. Harap pasang perangkat lunak sistem.';

  @override
  String get errorMemoryCardCorrupt =>
      'Citra kartu memori rusak atau gagal dalam verifikasi checksum.';

  @override
  String get errorPs3SaveDataSignature =>
      'Verifikasi data penyimpanan PS3 gagal (tanda tangan kriptografi PARAM.PFD rusak).';

  @override
  String get errorSaveStateVersion =>
      'Versi status penyimpanan tidak kompatibel dengan build core ini.';

  @override
  String get errorAudioInit =>
      'Gagal menginisialisasi sink audio latensi rendah.';

  @override
  String get errorGpuInit =>
      'Perender GPU perangkat keras gagal diinisialisasi. Periksa kompatibilitas Vulkan/Metal.';

  @override
  String get errorJitAllocation =>
      'Gagal mengalokasikan memori cache kode JIT yang dapat dieksekusi.';

  @override
  String get actionOk => 'OK';

  @override
  String get actionCancel => 'Batal';

  @override
  String get filterAll => 'Semua Konsol';

  @override
  String get actionHideHud => 'Sembunyikan HUD';

  @override
  String get actionShowHud => 'Tampilkan HUD';

  @override
  String get actionSimulateTrophy => 'Simulasi Buka Kunci Trofi';

  @override
  String saveStateSuccess(int slot) {
    return 'Simpan status berhasil diselesaikan (Slot $slot).';
  }

  @override
  String loadStateSuccess(int slot) {
    return 'Muat status berhasil dipulihkan (Slot $slot).';
  }

  @override
  String get trophyGrandMaster => 'Master Agung OmniStation';

  @override
  String unitMilliseconds(String value) {
    return '$value md';
  }

  @override
  String percentFormat(int value) {
    return '$value%';
  }

  @override
  String get statusRtlActive => 'RTL Aktif';

  @override
  String get tagRtl => '(RTL)';

  @override
  String get settingsGraphicsScaleDesc =>
      'Penskala Perangkat Keras Vulkan 1.3 / Metal 3';

  @override
  String get settingsResNative => '1x Asli';

  @override
  String get settingsRes1440p => '2x (1440p Quad HD)';

  @override
  String get settingsRes4k => '4x (4K Ultra HD)';

  @override
  String get settingsRes8k => '8x (8K Ekstrem)';

  @override
  String get settingsShaderDesc => 'Saluran Shader Real-Time Impeller';

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
  String get trophyPioneerTitle => 'Pelopor OmniStation';

  @override
  String get trophyPioneerDesc =>
      'Menjalankan emulator multi-sistem OmniStation untuk pertama kalinya.';

  @override
  String get trophyVeteranTitle => 'Veteran Perangkat Keras';

  @override
  String get trophyVeteranDesc =>
      'Mengonfigurasi saluran tekstur zero-copy Metal 3 dan Vulkan 1.3.';

  @override
  String get trophyCellMasterTitle => 'Master Cell Broadband Engine';

  @override
  String get trophyCellMasterDesc =>
      'Menjalankan PPE PowerPC dan 6 thread SPU secara bersamaan tanpa jeda.';

  @override
  String get trophyArchitectTitle => 'Arsitek Platinum';

  @override
  String get trophyArchitectDesc =>
      'Mencapai 100% cakupan pengujian di C++23, Rust, dan Flutter 3.x.';

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
      'EP0001-BLES00001_00.rap tidak ditemukan di exdata';

  @override
  String get defaultGameTitle => 'Game OmniStation';

  @override
  String get actionImportGame => 'Impor Game';

  @override
  String get actionDeleteGame => 'Hapus Game';

  @override
  String get dialogDeleteGameConfirm =>
      'Apakah Anda yakin ingin menghapus game ini dari perpustakaan Anda?';

  @override
  String msgGameImportSuccess(String title) {
    return 'Game berhasil diimpor: $title';
  }

  @override
  String msgGameImportFailed(String error) {
    return 'Gagal mengimpor game: $error';
  }

  @override
  String get emptyLibraryTitle => 'Belum Ada Game Terinstal';

  @override
  String get emptyLibraryDesc =>
      'Impor ROM atau image disk (.smc, .sfc, .msc, .iso, .zip, .pkg, .bin) untuk mulai bermain.';

  @override
  String get storageTotalAppSpace => 'Total Penyimpanan Digunakan';

  @override
  String get storageGamesSpace => 'Game Terinstal';

  @override
  String get storageSavesSpace => 'State Penyimpanan & SRAM';

  @override
  String get storageCardsSpace => 'Kartu Memori Virtual';

  @override
  String get storageFreeSpace => 'Ruang Bebas Perangkat';

  @override
  String get storageClearCache => 'Hapus Cache';

  @override
  String get storageClearCacheSuccess => 'Cache berhasil dibersihkan.';

  @override
  String get emptyTrophiesTitle => 'Belum Ada Trofi Diperoleh';

  @override
  String get emptyTrophiesDesc =>
      'Mainkan game dan selesaikan pencapaian untuk membuka trofi.';

  @override
  String get actionScanDirectory => 'Pindai Folder';

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
