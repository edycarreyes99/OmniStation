// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'OmniStation';

  @override
  String get tagline => 'Hochleistungs-Multisystem-Emulator';

  @override
  String get navLibrary => 'Spielebibliothek';

  @override
  String get navStorage => 'Speicherverwaltung';

  @override
  String get navTrophies => 'Trophäen';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get platformSnes => 'Super Nintendo';

  @override
  String get platformPs1 => 'PlayStation 1';

  @override
  String get platformPs2 => 'PlayStation 2';

  @override
  String get platformPs3 => 'PlayStation 3';

  @override
  String get statusReady => 'Bereit';

  @override
  String get statusRunning => 'Wird ausgeführt';

  @override
  String get statusPaused => 'Pausiert';

  @override
  String get statusStopped => 'Angehalten';

  @override
  String get statusCompilingShaders => 'Shader werden kompiliert...';

  @override
  String get statusBootingKernel => 'Kernel wird gestartet...';

  @override
  String get statusLoadingDisc => 'Optisches Medium wird geladen...';

  @override
  String get telemetryFps => 'FPS';

  @override
  String get telemetryFrameTime => 'Frame-Zeit';

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
  String get actionPlay => 'Spielen';

  @override
  String get actionPause => 'Pausieren';

  @override
  String get actionResume => 'Fortsetzen';

  @override
  String get actionStop => 'Beenden';

  @override
  String get actionRestart => 'Neu starten';

  @override
  String get actionLoadState => 'Spielstand laden';

  @override
  String get actionSaveState => 'Spielstand speichern';

  @override
  String get actionQuickMenu => 'Schnellmenü';

  @override
  String get actionInstallPkg => 'PKG/PUP installieren';

  @override
  String get actionInsertDisc => 'Disc einlegen';

  @override
  String get actionEjectDisc => 'Disc auswerfen';

  @override
  String get storageMemoryCard => 'Memory Card';

  @override
  String get storageMemoryCardSlot1 => 'Memory Card Steckplatz 1';

  @override
  String get storageMemoryCardSlot2 => 'Memory Card Steckplatz 2';

  @override
  String get storagePs3Hdd => 'Virtuelle PS3-Festplatte';

  @override
  String storageBlocksFree(int count) {
    return '$count Blöcke frei';
  }

  @override
  String get storageFormat => 'Speicherkarte formatieren';

  @override
  String get storageFormatConfirm =>
      'Sind Sie sicher, dass Sie diese Memory Card formatieren möchten? Alle Speicherdaten werden unwiderruflich gelöscht.';

  @override
  String get storageFormatSuccess => 'Memory Card erfolgreich formatiert.';

  @override
  String get trophyUnlocked => 'Trophäe freigeschaltet!';

  @override
  String get trophyBronze => 'Bronze';

  @override
  String get trophySilver => 'Silber';

  @override
  String get trophyGold => 'Gold';

  @override
  String get trophyPlatinum => 'Platin';

  @override
  String get settingsGeneral => 'Allgemein';

  @override
  String get settingsGraphics => 'Grafik';

  @override
  String get settingsAudio => 'Audio';

  @override
  String get settingsInput => 'Eingabe & Controller';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsTheme => 'Design';

  @override
  String get settingsThemeLight => 'Helles Design';

  @override
  String get settingsThemeDark => 'Dunkles Design';

  @override
  String get settingsThemeSystem => 'Systemstandard';

  @override
  String get settingsInternalResolution => 'Interne Auflösungsskalierung';

  @override
  String get settingsShaderPreset => 'Post-Processing-Filter';

  @override
  String get settingsShaderNone => 'Bilinear';

  @override
  String get settingsShaderCrt => 'CRT Royale';

  @override
  String get settingsShaderScanlines => 'Scanlines';

  @override
  String get errorTitle => 'Emulationsfehler';

  @override
  String get errorUnknown =>
      'Während der Emulation ist ein unerwarteter Fehler aufgetreten.';

  @override
  String get errorDiscRead =>
      'Fehler beim Lesen des optischen Disc-Abbilds. Die Datei ist möglicherweise beschädigt.';

  @override
  String get errorUdfFs =>
      'Fehler beim Parsen des Blu-ray UDF 2.50 Dateisystems.';

  @override
  String get errorIsoDecryption =>
      'Verschlüsselte PS3-Disc erkannt. Fehlender oder ungültiger Entschlüsselungsschlüssel (.ird / .dkey).';

  @override
  String get errorParamSfo =>
      'Fehler beim Lesen oder Parsen der PARAM.SFO-Metadaten.';

  @override
  String get errorSelfDecryption =>
      'Fehler beim Entschlüsseln der SELF/SPRX-Binärdatei. SCE/NPDRM-Signatur ungültig.';

  @override
  String get errorPkgRapMissing =>
      'Fehlende .rap-Lizenzdatei für das installierte PKG-Paket.';

  @override
  String get errorFirmwareMissing =>
      'Erforderliche Firmware- oder BIOS-Datei wurde nicht gefunden. Bitte installieren.';

  @override
  String get errorMemoryCardCorrupt =>
      'Memory-Card-Abbild ist beschädigt oder die Prüfsummenüberprüfung ist fehlgeschlagen.';

  @override
  String get errorPs3SaveDataSignature =>
      'PS3-Speicherdatenüberprüfung fehlgeschlagen (beschädigte PARAM.PFD-Signatur).';

  @override
  String get errorSaveStateVersion =>
      'Die Version des Speicherstands ist mit dieser Kernversion nicht kompatibel.';

  @override
  String get errorAudioInit =>
      'Initialisierung der Audioausgabe mit niedriger Latenz fehlgeschlagen.';

  @override
  String get errorGpuInit =>
      'Hardware-GPU-Renderer konnte nicht initialisiert werden. Bitte Vulkan/Metal überprüfen.';

  @override
  String get errorJitAllocation =>
      'Zuweisung von ausführbarem JIT-Codespeicher fehlgeschlagen.';

  @override
  String get actionOk => 'OK';

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get filterAll => 'Alle Konsolen';

  @override
  String get actionHideHud => 'HUD ausblenden';

  @override
  String get actionShowHud => 'HUD anzeigen';

  @override
  String get actionSimulateTrophy => 'Trophäenfreischaltung simulieren';

  @override
  String saveStateSuccess(int slot) {
    return 'Spielstand erfolgreich gespeichert (Slot $slot).';
  }

  @override
  String loadStateSuccess(int slot) {
    return 'Spielstand erfolgreich geladen (Slot $slot).';
  }

  @override
  String get trophyGrandMaster => 'OmniStation Großmeister';

  @override
  String unitMilliseconds(String value) {
    return '$value ms';
  }

  @override
  String percentFormat(int value) {
    return '$value%';
  }

  @override
  String get statusRtlActive => 'RTL Aktiv';

  @override
  String get tagRtl => '(RTL)';

  @override
  String get settingsGraphicsScaleDesc =>
      'Vulkan 1.3 / Metal 3 Hardware-Skalierung';

  @override
  String get settingsResNative => '1x Nativ';

  @override
  String get settingsRes1440p => '2x (1440p Quad HD)';

  @override
  String get settingsRes4k => '4x (4K Ultra HD)';

  @override
  String get settingsRes8k => '8x (8K Extrem)';

  @override
  String get settingsShaderDesc => 'Impeller Echtzeit-Shader-Pipeline';

  @override
  String get storagePs1Capacity => 'PlayStation 1 (128 KB)';

  @override
  String get storagePs2Capacity => 'PlayStation 2 (8 MB)';

  @override
  String get storagePfdValid => 'PARAM.PFD Gültig';

  @override
  String get storagePs3HddPath => 'dev_hdd0/home/00000001/savedata';

  @override
  String storagePs3HddUsage(String used, String total) {
    return '$used GB / $total GB';
  }

  @override
  String get trophyPioneerTitle => 'OmniStation Pionier';

  @override
  String get trophyPioneerDesc =>
      'OmniStation Multi-System-Emulator zum ersten Mal gestartet.';

  @override
  String get trophyVeteranTitle => 'Hardware-Veteran';

  @override
  String get trophyVeteranDesc =>
      'Metal 3 und Vulkan 1.3 Zero-Copy-Textur-Pipelines konfiguriert.';

  @override
  String get trophyCellMasterTitle => 'Meister der Cell Broadband Engine';

  @override
  String get trophyCellMasterDesc =>
      'PowerPC PPE und 6 SPU-Threads gleichzeitig ohne Jitter ausgeführt.';

  @override
  String get trophyArchitectTitle => 'Platin-Architekt';

  @override
  String get trophyArchitectDesc =>
      '100% Testabdeckung in C++23, Rust und Flutter 3.x erreicht.';

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
      'EP0001-BLES00001_00.rap nicht in exdata gefunden';

  @override
  String get defaultGameTitle => 'OmniStation Spiel';

  @override
  String get actionImportGame => 'Spiel importieren';

  @override
  String get actionDeleteGame => 'Spiel löschen';

  @override
  String get dialogDeleteGameConfirm =>
      'Möchten Sie dieses Spiel wirklich aus Ihrer Bibliothek löschen?';

  @override
  String msgGameImportSuccess(String title) {
    return 'Spiel erfolgreich importiert: $title';
  }

  @override
  String msgGameImportFailed(String error) {
    return 'Fehler beim Importieren des Spiels: $error';
  }

  @override
  String get emptyLibraryTitle => 'Keine Spiele installiert';

  @override
  String get emptyLibraryDesc =>
      'Importieren Sie ROMs oder Disc-Images (.smc, .sfc, .msc, .iso, .zip, .pkg, .bin), um zu spielen.';

  @override
  String get storageTotalAppSpace => 'Gesamter genutzter Speicher';

  @override
  String get storageGamesSpace => 'Installierte Spiele';

  @override
  String get storageSavesSpace => 'Speicherstände & SRAM';

  @override
  String get storageCardsSpace => 'Virtuelle Speicherkarten';

  @override
  String get storageFreeSpace => 'Freier Gerätespeicher';

  @override
  String get storageClearCache => 'Cache leeren';

  @override
  String get storageClearCacheSuccess => 'Cache erfolgreich geleert.';

  @override
  String get emptyTrophiesTitle => 'Keine Trophäen verdient';

  @override
  String get emptyTrophiesDesc =>
      'Spielen Sie Spiele und meistern Sie Meilensteine, um Trophäen zu erhalten.';

  @override
  String get actionScanDirectory => 'Ordner scannen';

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
