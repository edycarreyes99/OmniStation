// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'OmniStation';

  @override
  String get tagline => 'Émulateur Multi-Système Haute Performance';

  @override
  String get navLibrary => 'Bibliothèque';

  @override
  String get navStorage => 'Stockage';

  @override
  String get navTrophies => 'Trophées';

  @override
  String get navSettings => 'Paramètres';

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
  String get statusReady => 'Prêt';

  @override
  String get statusRunning => 'En cours d\'exécution';

  @override
  String get statusPaused => 'En pause';

  @override
  String get statusStopped => 'Arrêté';

  @override
  String get statusCompilingShaders => 'Compilation des shaders...';

  @override
  String get statusBootingKernel => 'Démarrage du noyau...';

  @override
  String get statusLoadingDisc => 'Chargement du disque optique...';

  @override
  String get telemetryFps => 'FPS';

  @override
  String get telemetryFrameTime => 'Temps de trame';

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
  String get actionPlay => 'Jouer';

  @override
  String get actionPause => 'Pause';

  @override
  String get actionResume => 'Reprendre';

  @override
  String get actionStop => 'Arrêter';

  @override
  String get actionRestart => 'Redémarrer';

  @override
  String get actionLoadState => 'Charger l\'état';

  @override
  String get actionSaveState => 'Sauvegarder l\'état';

  @override
  String get actionQuickMenu => 'Menu rapide';

  @override
  String get actionInstallPkg => 'Installer PKG/PUP';

  @override
  String get actionInsertDisc => 'Insérer un disque';

  @override
  String get actionEjectDisc => 'Éjecter le disque';

  @override
  String get storageMemoryCard => 'Carte mémoire';

  @override
  String get storageMemoryCardSlot1 => 'Carte mémoire Fente 1';

  @override
  String get storageMemoryCardSlot2 => 'Carte mémoire Fente 2';

  @override
  String get storagePs3Hdd => 'Disque dur virtuel PS3';

  @override
  String storageBlocksFree(int count) {
    return '$count blocs libres';
  }

  @override
  String get storageFormat => 'Formater la carte';

  @override
  String get storageFormatConfirm =>
      'Êtes-vous sûr de vouloir formater cette carte mémoire ? Toutes les données de sauvegarde seront définitivement effacées.';

  @override
  String get storageFormatSuccess => 'Carte mémoire formatée avec succès.';

  @override
  String get trophyUnlocked => 'Trophée débloqué !';

  @override
  String get trophyBronze => 'Bronze';

  @override
  String get trophySilver => 'Argent';

  @override
  String get trophyGold => 'Or';

  @override
  String get trophyPlatinum => 'Platine';

  @override
  String get settingsGeneral => 'Général';

  @override
  String get settingsGraphics => 'Graphismes';

  @override
  String get settingsAudio => 'Audio';

  @override
  String get settingsInput => 'Entrée & Manettes';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeLight => 'Mode clair';

  @override
  String get settingsThemeDark => 'Mode sombre';

  @override
  String get settingsThemeSystem => 'Par défaut du système';

  @override
  String get settingsInternalResolution =>
      'Mise à l\'échelle de résolution interne';

  @override
  String get settingsShaderPreset => 'Filtre de post-traitement';

  @override
  String get settingsShaderNone => 'Bilinéaire';

  @override
  String get settingsShaderCrt => 'CRT Royale';

  @override
  String get settingsShaderScanlines => 'Lignes de balayage';

  @override
  String get errorTitle => 'Erreur d\'émulation';

  @override
  String get errorUnknown =>
      'Une erreur inattendue est survenue pendant l\'émulation.';

  @override
  String get errorDiscRead =>
      'Échec de la lecture de l\'image disque. Le fichier est peut-être corrompu ou inaccessible.';

  @override
  String get errorUdfFs =>
      'Échec de l\'analyse du système de fichiers Blu-ray UDF 2.50.';

  @override
  String get errorIsoDecryption =>
      'Disque PS3 chiffré détecté. Clé de déchiffrement manquante ou invalide (.ird / .dkey).';

  @override
  String get errorParamSfo =>
      'Échec de la lecture ou de l\'analyse des métadonnées PARAM.SFO.';

  @override
  String get errorSelfDecryption =>
      'Échec du déchiffrement du binaire SELF/SPRX. Échec de la vérification de signature SCE/NPDRM.';

  @override
  String get errorPkgRapMissing =>
      'Fichier de licence .rap manquant pour le paquet PKG installé.';

  @override
  String get errorFirmwareMissing =>
      'Fichier de micrologiciel ou BIOS requis introuvable. Veuillez installer le logiciel système.';

  @override
  String get errorMemoryCardCorrupt =>
      'L\'image de la carte mémoire est corrompue ou la somme de contrôle est invalide.';

  @override
  String get errorPs3SaveDataSignature =>
      'Échec de vérification des données de sauvegarde PS3 (signature PARAM.PFD corrompue).';

  @override
  String get errorSaveStateVersion =>
      'La version de la sauvegarde instantanée est incompatible avec ce noyau.';

  @override
  String get errorAudioInit =>
      'Échec de l\'initialisation du périphérique audio à faible latence.';

  @override
  String get errorGpuInit =>
      'Le moteur de rendu GPU matériel n\'a pas pu être initialisé. Vérifiez la compatibilité Vulkan/Metal.';

  @override
  String get errorJitAllocation =>
      'Échec de l\'allocation de mémoire de cache de code JIT exécutable.';

  @override
  String get actionOk => 'OK';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get filterAll => 'Toutes les Consoles';

  @override
  String get actionHideHud => 'Masquer l\'ATH';

  @override
  String get actionShowHud => 'Afficher l\'ATH';

  @override
  String get actionSimulateTrophy => 'Simuler le Déblocage d\'un Trophée';

  @override
  String saveStateSuccess(int slot) {
    return 'Sauvegarde instantanée réussie (Emplacement $slot).';
  }

  @override
  String loadStateSuccess(int slot) {
    return 'Chargement instantané réussi (Emplacement $slot).';
  }

  @override
  String get trophyGrandMaster => 'Grand Maître OmniStation';

  @override
  String unitMilliseconds(String value) {
    return '$value ms';
  }

  @override
  String percentFormat(int value) {
    return '$value%';
  }

  @override
  String get statusRtlActive => 'RTL Actif';

  @override
  String get tagRtl => '(RTL)';

  @override
  String get settingsGraphicsScaleDesc =>
      'Mise à l\'échelle matérielle Vulkan 1.3 / Metal 3';

  @override
  String get settingsResNative => '1x Natif';

  @override
  String get settingsRes1440p => '2x (1440p Quad HD)';

  @override
  String get settingsRes4k => '4x (4K Ultra HD)';

  @override
  String get settingsRes8k => '8x (8K Extrême)';

  @override
  String get settingsShaderDesc => 'Pipeline de Shaders en Temps Réel Impeller';

  @override
  String get storagePs1Capacity => 'PlayStation 1 (128 Ko)';

  @override
  String get storagePs2Capacity => 'PlayStation 2 (8 Mo)';

  @override
  String get storagePfdValid => 'PARAM.PFD Valide';

  @override
  String get storagePs3HddPath => 'dev_hdd0/home/00000001/savedata';

  @override
  String storagePs3HddUsage(String used, String total) {
    return '$used Go / $total Go';
  }

  @override
  String get trophyPioneerTitle => 'Pionnier OmniStation';

  @override
  String get trophyPioneerDesc =>
      'Démarrage de l\'émulateur multi-système OmniStation pour la première fois.';

  @override
  String get trophyVeteranTitle => 'Vétéran du Matériel';

  @override
  String get trophyVeteranDesc =>
      'Configuration des pipelines de textures zéro-copie Metal 3 et Vulkan 1.3.';

  @override
  String get trophyCellMasterTitle => 'Maître du Cell Broadband Engine';

  @override
  String get trophyCellMasterDesc =>
      'Exécution conjointe du PPE PowerPC et de 6 threads SPU sans gigue.';

  @override
  String get trophyArchitectTitle => 'Architecte Platine';

  @override
  String get trophyArchitectDesc =>
      'Couverture de test de 100% atteinte sur C++23, Rust et Flutter 3.x.';

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
      'EP0001-BLES00001_00.rap introuvable dans exdata';

  @override
  String get defaultGameTitle => 'Jeu OmniStation';

  @override
  String get actionImportGame => 'Importer un jeu';

  @override
  String get actionDeleteGame => 'Supprimer le jeu';

  @override
  String get dialogDeleteGameConfirm =>
      'Voulez-vous vraiment supprimer ce jeu de votre bibliothèque ?';

  @override
  String msgGameImportSuccess(String title) {
    return 'Jeu importé avec succès : $title';
  }

  @override
  String msgGameImportFailed(String error) {
    return 'Échec de l\'importation du jeu : $error';
  }

  @override
  String get emptyLibraryTitle => 'Aucun jeu installé';

  @override
  String get emptyLibraryDesc =>
      'Importez des ROMs ou images de disque (.smc, .sfc, .msc, .iso, .zip, .pkg, .bin) pour commencer à jouer.';

  @override
  String get storageTotalAppSpace => 'Espace de stockage total utilisé';

  @override
  String get storageGamesSpace => 'Jeux installés';

  @override
  String get storageSavesSpace => 'Sauvegardes et SRAM';

  @override
  String get storageCardsSpace => 'Cartes mémoire virtuelles';

  @override
  String get storageFreeSpace => 'Espace libre sur l\'appareil';

  @override
  String get storageClearCache => 'Vider le cache';

  @override
  String get storageClearCacheSuccess => 'Cache vidé avec succès.';

  @override
  String get emptyTrophiesTitle => 'Aucun trophée débloqué';

  @override
  String get emptyTrophiesDesc =>
      'Jouez aux jeux et réussissez des étapes pour remporter des trophées.';

  @override
  String get actionScanDirectory => 'Scanner le dossier';

  @override
  String unitGigabytes(String value) {
    return '$value Go';
  }

  @override
  String unitMegabytes(String value) {
    return '$value Mo';
  }

  @override
  String unitKilobytes(String value) {
    return '$value Ko';
  }
}
