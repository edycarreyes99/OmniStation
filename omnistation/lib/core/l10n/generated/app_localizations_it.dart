// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'OmniStation';

  @override
  String get tagline => 'Emulatore Multi-Sistema ad Alte Prestazioni';

  @override
  String get navLibrary => 'Libreria';

  @override
  String get navStorage => 'Archiviazione';

  @override
  String get navTrophies => 'Trofei';

  @override
  String get navSettings => 'Impostazioni';

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
  String get statusReady => 'Pronto';

  @override
  String get statusRunning => 'In esecuzione';

  @override
  String get statusPaused => 'In pausa';

  @override
  String get statusStopped => 'Arrestato';

  @override
  String get statusCompilingShaders => 'Compilazione shader in corso...';

  @override
  String get statusBootingKernel => 'Avvio del kernel...';

  @override
  String get statusLoadingDisc => 'Caricamento disco ottico...';

  @override
  String get telemetryFps => 'FPS';

  @override
  String get telemetryFrameTime => 'Tempo di frame';

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
  String get actionPlay => 'Gioca';

  @override
  String get actionPause => 'Pausa';

  @override
  String get actionResume => 'Riprendi';

  @override
  String get actionStop => 'Ferma';

  @override
  String get actionRestart => 'Riavvia';

  @override
  String get actionLoadState => 'Carica Stato';

  @override
  String get actionSaveState => 'Salva Stato';

  @override
  String get actionQuickMenu => 'Menu rapido';

  @override
  String get actionInstallPkg => 'Installa PKG/PUP';

  @override
  String get actionInsertDisc => 'Inserisci Disco';

  @override
  String get actionEjectDisc => 'Espelli Disco';

  @override
  String get storageMemoryCard => 'Memory Card';

  @override
  String get storageMemoryCardSlot1 => 'Memory Card Slot 1';

  @override
  String get storageMemoryCardSlot2 => 'Memory Card Slot 2';

  @override
  String get storagePs3Hdd => 'HDD Virtuale PS3';

  @override
  String storageBlocksFree(int count) {
    return '$count blocchi liberi';
  }

  @override
  String get storageFormat => 'Formatta scheda';

  @override
  String get storageFormatConfirm =>
      'Sei sicuro di voler formattare questa Memory Card? Tutti i dati di salvataggio verranno eliminati definitivamente.';

  @override
  String get storageFormatSuccess => 'Memory Card formattata con successo.';

  @override
  String get trophyUnlocked => 'Trofeo Sbloccato!';

  @override
  String get trophyBronze => 'Bronzo';

  @override
  String get trophySilver => 'Argento';

  @override
  String get trophyGold => 'Oro';

  @override
  String get trophyPlatinum => 'Platino';

  @override
  String get settingsGeneral => 'Generale';

  @override
  String get settingsGraphics => 'Grafica';

  @override
  String get settingsAudio => 'Audio';

  @override
  String get settingsInput => 'Input & Controller';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeLight => 'Tema Chiaro';

  @override
  String get settingsThemeDark => 'Tema Scuro';

  @override
  String get settingsThemeSystem => 'Predefinito di Sistema';

  @override
  String get settingsInternalResolution => 'Scala Risoluzione Interna';

  @override
  String get settingsShaderPreset => 'Filtro Post-Elaborazione';

  @override
  String get settingsShaderNone => 'Bilineare';

  @override
  String get settingsShaderCrt => 'CRT Royale';

  @override
  String get settingsShaderScanlines => 'Scanlines';

  @override
  String get errorTitle => 'Errore di Emulazione';

  @override
  String get errorUnknown =>
      'Si è verificato un errore imprevisto durante l\'emulazione.';

  @override
  String get errorDiscRead =>
      'Impossibile leggere l\'immagine del disco ottico. Il file potrebbe essere danneggiato.';

  @override
  String get errorUdfFs =>
      'Analisi del file system Blu-ray UDF 2.50 non riuscita.';

  @override
  String get errorIsoDecryption =>
      'Rilevato disco PS3 crittografato. Chiave di decrittazione mancante o non valida (.ird / .dkey).';

  @override
  String get errorParamSfo =>
      'Lettura o analisi dei metadati PARAM.SFO non riuscita.';

  @override
  String get errorSelfDecryption =>
      'Decrittazione del binario SELF/SPRX fallita. Verifica firma SCE/NPDRM non riuscita.';

  @override
  String get errorPkgRapMissing =>
      'File di licenza .rap mancante per il pacchetto PKG installato.';

  @override
  String get errorFirmwareMissing =>
      'File firmware o BIOS richiesto non trovato. Installa il software di sistema.';

  @override
  String get errorMemoryCardCorrupt =>
      'Immagine della Memory Card danneggiata o checksum non corrispondente.';

  @override
  String get errorPs3SaveDataSignature =>
      'Verifica dei dati di salvataggio PS3 fallita (firma PARAM.PFD danneggiata).';

  @override
  String get errorSaveStateVersion =>
      'La versione dello stato di salvataggio è incompatibile con questo core.';

  @override
  String get errorAudioInit =>
      'Inizializzazione sink audio a bassa latenza non riuscita.';

  @override
  String get errorGpuInit =>
      'Inizializzazione del renderer GPU hardware non riuscita. Verifica il supporto Vulkan/Metal.';

  @override
  String get errorJitAllocation =>
      'Allocazione della memoria della cache di codice eseguibile JIT non riuscita.';

  @override
  String get actionOk => 'OK';

  @override
  String get actionCancel => 'Annulla';

  @override
  String get filterAll => 'Tutte le Console';

  @override
  String get actionHideHud => 'Nascondi HUD';

  @override
  String get actionShowHud => 'Mostra HUD';

  @override
  String get actionSimulateTrophy => 'Simula Sblocco Trofeo';

  @override
  String saveStateSuccess(int slot) {
    return 'Salvataggio completato con successo (Slot $slot).';
  }

  @override
  String loadStateSuccess(int slot) {
    return 'Stato caricato con successo (Slot $slot).';
  }

  @override
  String get trophyGrandMaster => 'Gran Maestro OmniStation';

  @override
  String unitMilliseconds(String value) {
    return '$value ms';
  }

  @override
  String percentFormat(int value) {
    return '$value%';
  }

  @override
  String get statusRtlActive => 'RTL Attivo';

  @override
  String get tagRtl => '(RTL)';

  @override
  String get settingsGraphicsScaleDesc =>
      'Ridimensionamento Hardware Vulkan 1.3 / Metal 3';

  @override
  String get settingsResNative => '1x Nativo';

  @override
  String get settingsRes1440p => '2x (1440p Quad HD)';

  @override
  String get settingsRes4k => '4x (4K Ultra HD)';

  @override
  String get settingsRes8k => '8x (8K Estremo)';

  @override
  String get settingsShaderDesc => 'Pipeline Shader in Tempo Reale Impeller';

  @override
  String get storagePs1Capacity => 'PlayStation 1 (128 KB)';

  @override
  String get storagePs2Capacity => 'PlayStation 2 (8 MB)';

  @override
  String get storagePfdValid => 'PARAM.PFD Valido';

  @override
  String get storagePs3HddPath => 'dev_hdd0/home/00000001/savedata';

  @override
  String storagePs3HddUsage(String used, String total) {
    return '$used GB / $total GB';
  }

  @override
  String get trophyPioneerTitle => 'Pioniere OmniStation';

  @override
  String get trophyPioneerDesc =>
      'Avviato l\'emulatore multi-sistema OmniStation per la prima volta.';

  @override
  String get trophyVeteranTitle => 'Veterano dell\'Hardware';

  @override
  String get trophyVeteranDesc =>
      'Configurate le pipeline di texture zero-copy Metal 3 e Vulkan 1.3.';

  @override
  String get trophyCellMasterTitle => 'Maestro del Cell Broadband Engine';

  @override
  String get trophyCellMasterDesc =>
      'Esecuzione simultanea di PPE PowerPC e 6 thread SPU senza jitter.';

  @override
  String get trophyArchitectTitle => 'Architetto Platino';

  @override
  String get trophyArchitectDesc =>
      'Raggiunta la copertura di test al 100% su C++23, Rust e Flutter 3.x.';

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
      'EP0001-BLES00001_00.rap non trovato in exdata';

  @override
  String get defaultGameTitle => 'Gioco OmniStation';

  @override
  String get actionImportGame => 'Importa gioco';

  @override
  String get actionDeleteGame => 'Elimina gioco';

  @override
  String get dialogDeleteGameConfirm =>
      'Sei sicuro di voler rimuovere questo gioco dalla tua libreria?';

  @override
  String msgGameImportSuccess(String title) {
    return 'Gioco importato con successo: $title';
  }

  @override
  String msgGameImportFailed(String error) {
    return 'Impossibile importare il gioco: $error';
  }

  @override
  String get emptyLibraryTitle => 'Nessun gioco installato';

  @override
  String get emptyLibraryDesc =>
      'Importa ROM o immagini disco (.smc, .sfc, .msc, .iso, .zip, .pkg, .bin) per iniziare a giocare.';

  @override
  String get storageTotalAppSpace =>
      'Spazio di archiviazione totale utilizzato';

  @override
  String get storageGamesSpace => 'Giochi installati';

  @override
  String get storageSavesSpace => 'Salvataggi e SRAM';

  @override
  String get storageCardsSpace => 'Schede di memoria virtuali';

  @override
  String get storageFreeSpace => 'Spazio libero sul dispositivo';

  @override
  String get storageClearCache => 'Cancella cache';

  @override
  String get storageClearCacheSuccess => 'Cache cancellata con successo.';

  @override
  String get emptyTrophiesTitle => 'Nessun trofeo ottenuto';

  @override
  String get emptyTrophiesDesc =>
      'Gioca e completa gli obiettivi nei giochi per guadagnare trofei.';

  @override
  String get actionScanDirectory => 'Scansiona cartella';

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
