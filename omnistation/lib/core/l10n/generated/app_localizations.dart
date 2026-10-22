import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'OmniStation'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'High-Performance Multi-System Emulator'**
  String get tagline;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get navStorage;

  /// No description provided for @navTrophies.
  ///
  /// In en, this message translates to:
  /// **'Trophies'**
  String get navTrophies;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @platformSnes.
  ///
  /// In en, this message translates to:
  /// **'Super Nintendo'**
  String get platformSnes;

  /// No description provided for @platformPs1.
  ///
  /// In en, this message translates to:
  /// **'PlayStation 1'**
  String get platformPs1;

  /// No description provided for @platformPs2.
  ///
  /// In en, this message translates to:
  /// **'PlayStation 2'**
  String get platformPs2;

  /// No description provided for @platformPs3.
  ///
  /// In en, this message translates to:
  /// **'PlayStation 3'**
  String get platformPs3;

  /// No description provided for @platformPsp.
  ///
  /// In en, this message translates to:
  /// **'PlayStation Portable'**
  String get platformPsp;

  /// No description provided for @platformPsVita.
  ///
  /// In en, this message translates to:
  /// **'PlayStation Vita'**
  String get platformPsVita;

  /// No description provided for @platformWii.
  ///
  /// In en, this message translates to:
  /// **'Nintendo Wii'**
  String get platformWii;

  /// No description provided for @platformWiiU.
  ///
  /// In en, this message translates to:
  /// **'Nintendo Wii U'**
  String get platformWiiU;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statusReady;

  /// No description provided for @statusRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get statusRunning;

  /// No description provided for @statusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get statusPaused;

  /// No description provided for @statusStopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get statusStopped;

  /// No description provided for @statusCompilingShaders.
  ///
  /// In en, this message translates to:
  /// **'Compiling Shaders...'**
  String get statusCompilingShaders;

  /// No description provided for @statusBootingKernel.
  ///
  /// In en, this message translates to:
  /// **'Booting Kernel...'**
  String get statusBootingKernel;

  /// No description provided for @statusLoadingDisc.
  ///
  /// In en, this message translates to:
  /// **'Loading Optical Disc...'**
  String get statusLoadingDisc;

  /// No description provided for @telemetryFps.
  ///
  /// In en, this message translates to:
  /// **'FPS'**
  String get telemetryFps;

  /// No description provided for @telemetryFrameTime.
  ///
  /// In en, this message translates to:
  /// **'Frame Time'**
  String get telemetryFrameTime;

  /// No description provided for @telemetryPpu.
  ///
  /// In en, this message translates to:
  /// **'PPU'**
  String get telemetryPpu;

  /// No description provided for @telemetrySpu.
  ///
  /// In en, this message translates to:
  /// **'SPU'**
  String get telemetrySpu;

  /// No description provided for @telemetryEe.
  ///
  /// In en, this message translates to:
  /// **'EE'**
  String get telemetryEe;

  /// No description provided for @telemetryGs.
  ///
  /// In en, this message translates to:
  /// **'GS'**
  String get telemetryGs;

  /// No description provided for @telemetryRsx.
  ///
  /// In en, this message translates to:
  /// **'RSX'**
  String get telemetryRsx;

  /// No description provided for @telemetryAudioDrc.
  ///
  /// In en, this message translates to:
  /// **'DRC'**
  String get telemetryAudioDrc;

  /// No description provided for @actionPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get actionPlay;

  /// No description provided for @actionPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get actionPause;

  /// No description provided for @actionResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get actionResume;

  /// No description provided for @actionStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get actionStop;

  /// No description provided for @actionRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get actionRestart;

  /// No description provided for @actionLoadState.
  ///
  /// In en, this message translates to:
  /// **'Load State'**
  String get actionLoadState;

  /// No description provided for @actionSaveState.
  ///
  /// In en, this message translates to:
  /// **'Save State'**
  String get actionSaveState;

  /// No description provided for @actionQuickMenu.
  ///
  /// In en, this message translates to:
  /// **'Quick Menu'**
  String get actionQuickMenu;

  /// No description provided for @actionInstallPkg.
  ///
  /// In en, this message translates to:
  /// **'Install PKG/PUP'**
  String get actionInstallPkg;

  /// No description provided for @actionInsertDisc.
  ///
  /// In en, this message translates to:
  /// **'Insert Disc'**
  String get actionInsertDisc;

  /// No description provided for @actionEjectDisc.
  ///
  /// In en, this message translates to:
  /// **'Eject Disc'**
  String get actionEjectDisc;

  /// No description provided for @storageMemoryCard.
  ///
  /// In en, this message translates to:
  /// **'Memory Card'**
  String get storageMemoryCard;

  /// No description provided for @storageMemoryCardSlot1.
  ///
  /// In en, this message translates to:
  /// **'Memory Card Slot 1'**
  String get storageMemoryCardSlot1;

  /// No description provided for @storageMemoryCardSlot2.
  ///
  /// In en, this message translates to:
  /// **'Memory Card Slot 2'**
  String get storageMemoryCardSlot2;

  /// No description provided for @storagePs3Hdd.
  ///
  /// In en, this message translates to:
  /// **'PS3 Virtual HDD'**
  String get storagePs3Hdd;

  /// No description provided for @storageBlocksFree.
  ///
  /// In en, this message translates to:
  /// **'{count} blocks free'**
  String storageBlocksFree(int count);

  /// No description provided for @storageFormat.
  ///
  /// In en, this message translates to:
  /// **'Format Card'**
  String get storageFormat;

  /// No description provided for @storageFormatConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to format this Memory Card? All save data will be permanently erased.'**
  String get storageFormatConfirm;

  /// No description provided for @storageFormatSuccess.
  ///
  /// In en, this message translates to:
  /// **'Memory Card formatted successfully.'**
  String get storageFormatSuccess;

  /// No description provided for @trophyUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Trophy Unlocked!'**
  String get trophyUnlocked;

  /// No description provided for @trophyBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get trophyBronze;

  /// No description provided for @trophySilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get trophySilver;

  /// No description provided for @trophyGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get trophyGold;

  /// No description provided for @trophyPlatinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get trophyPlatinum;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsGraphics.
  ///
  /// In en, this message translates to:
  /// **'Graphics'**
  String get settingsGraphics;

  /// No description provided for @settingsAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get settingsAudio;

  /// No description provided for @settingsInput.
  ///
  /// In en, this message translates to:
  /// **'Input & Controllers'**
  String get settingsInput;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get settingsThemeSystem;

  /// No description provided for @settingsInternalResolution.
  ///
  /// In en, this message translates to:
  /// **'Internal Resolution Scaling'**
  String get settingsInternalResolution;

  /// No description provided for @settingsShaderPreset.
  ///
  /// In en, this message translates to:
  /// **'Post-Processing Filter'**
  String get settingsShaderPreset;

  /// No description provided for @settingsShaderNone.
  ///
  /// In en, this message translates to:
  /// **'Bilinear'**
  String get settingsShaderNone;

  /// No description provided for @settingsShaderCrt.
  ///
  /// In en, this message translates to:
  /// **'CRT Royale'**
  String get settingsShaderCrt;

  /// No description provided for @settingsShaderScanlines.
  ///
  /// In en, this message translates to:
  /// **'Scanlines'**
  String get settingsShaderScanlines;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Emulation Error'**
  String get errorTitle;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred during emulation.'**
  String get errorUnknown;

  /// No description provided for @errorDiscRead.
  ///
  /// In en, this message translates to:
  /// **'Failed to read optical disc image. The file may be corrupt or inaccessible.'**
  String get errorDiscRead;

  /// No description provided for @errorUdfFs.
  ///
  /// In en, this message translates to:
  /// **'Failed to parse Blu-ray UDF 2.50 file system.'**
  String get errorUdfFs;

  /// No description provided for @errorIsoDecryption.
  ///
  /// In en, this message translates to:
  /// **'Encrypted PS3 disc detected. Missing or invalid decryption key (.ird / .dkey).'**
  String get errorIsoDecryption;

  /// No description provided for @errorParamSfo.
  ///
  /// In en, this message translates to:
  /// **'Failed to read or parse PARAM.SFO metadata.'**
  String get errorParamSfo;

  /// No description provided for @errorSelfDecryption.
  ///
  /// In en, this message translates to:
  /// **'Failed to decrypt SELF/SPRX binary. SCE/NPDRM signature check failed.'**
  String get errorSelfDecryption;

  /// No description provided for @errorPkgRapMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing .rap license file for installed PKG package.'**
  String get errorPkgRapMissing;

  /// No description provided for @errorFirmwareMissing.
  ///
  /// In en, this message translates to:
  /// **'Required firmware or BIOS file was not found. Please install the system software.'**
  String get errorFirmwareMissing;

  /// No description provided for @errorMemoryCardCorrupt.
  ///
  /// In en, this message translates to:
  /// **'Memory card image is corrupted or failed checksum verification.'**
  String get errorMemoryCardCorrupt;

  /// No description provided for @errorPs3SaveDataSignature.
  ///
  /// In en, this message translates to:
  /// **'PS3 save data verification failed (corrupted PARAM.PFD signature).'**
  String get errorPs3SaveDataSignature;

  /// No description provided for @errorSaveStateVersion.
  ///
  /// In en, this message translates to:
  /// **'Save state version is incompatible with this core build.'**
  String get errorSaveStateVersion;

  /// No description provided for @errorAudioInit.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize low-latency audio sink.'**
  String get errorAudioInit;

  /// No description provided for @errorGpuInit.
  ///
  /// In en, this message translates to:
  /// **'Hardware GPU renderer failed to initialize. Check Vulkan/Metal compatibility.'**
  String get errorGpuInit;

  /// No description provided for @errorJitAllocation.
  ///
  /// In en, this message translates to:
  /// **'Failed to allocate executable JIT code cache memory.'**
  String get errorJitAllocation;

  /// No description provided for @actionOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All Consoles'**
  String get filterAll;

  /// No description provided for @actionHideHud.
  ///
  /// In en, this message translates to:
  /// **'Hide HUD'**
  String get actionHideHud;

  /// No description provided for @actionShowHud.
  ///
  /// In en, this message translates to:
  /// **'Show HUD'**
  String get actionShowHud;

  /// No description provided for @actionSimulateTrophy.
  ///
  /// In en, this message translates to:
  /// **'Simulate Trophy Unlock'**
  String get actionSimulateTrophy;

  /// No description provided for @saveStateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Save state completed successfully (Slot {slot}).'**
  String saveStateSuccess(int slot);

  /// No description provided for @loadStateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Load state restored successfully (Slot {slot}).'**
  String loadStateSuccess(int slot);

  /// No description provided for @trophyGrandMaster.
  ///
  /// In en, this message translates to:
  /// **'OmniStation Grand Master'**
  String get trophyGrandMaster;

  /// No description provided for @unitMilliseconds.
  ///
  /// In en, this message translates to:
  /// **'{value} ms'**
  String unitMilliseconds(String value);

  /// No description provided for @percentFormat.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percentFormat(int value);

  /// No description provided for @statusRtlActive.
  ///
  /// In en, this message translates to:
  /// **'RTL Active'**
  String get statusRtlActive;

  /// No description provided for @tagRtl.
  ///
  /// In en, this message translates to:
  /// **'(RTL)'**
  String get tagRtl;

  /// No description provided for @settingsGraphicsScaleDesc.
  ///
  /// In en, this message translates to:
  /// **'Vulkan 1.3 / Metal 3 Hardware Scaler'**
  String get settingsGraphicsScaleDesc;

  /// No description provided for @settingsResNative.
  ///
  /// In en, this message translates to:
  /// **'1x Native'**
  String get settingsResNative;

  /// No description provided for @settingsRes1440p.
  ///
  /// In en, this message translates to:
  /// **'2x (1440p Quad HD)'**
  String get settingsRes1440p;

  /// No description provided for @settingsRes4k.
  ///
  /// In en, this message translates to:
  /// **'4x (4K Ultra HD)'**
  String get settingsRes4k;

  /// No description provided for @settingsRes8k.
  ///
  /// In en, this message translates to:
  /// **'8x (8K Extreme)'**
  String get settingsRes8k;

  /// No description provided for @settingsShaderDesc.
  ///
  /// In en, this message translates to:
  /// **'Impeller Real-Time Shader Pipeline'**
  String get settingsShaderDesc;

  /// No description provided for @storagePs1Capacity.
  ///
  /// In en, this message translates to:
  /// **'PlayStation 1 (128 KB)'**
  String get storagePs1Capacity;

  /// No description provided for @storagePs2Capacity.
  ///
  /// In en, this message translates to:
  /// **'PlayStation 2 (8 MB)'**
  String get storagePs2Capacity;

  /// No description provided for @storagePfdValid.
  ///
  /// In en, this message translates to:
  /// **'PARAM.PFD Valid'**
  String get storagePfdValid;

  /// No description provided for @storagePs3HddPath.
  ///
  /// In en, this message translates to:
  /// **'dev_hdd0/home/00000001/savedata'**
  String get storagePs3HddPath;

  /// No description provided for @storagePs3HddUsage.
  ///
  /// In en, this message translates to:
  /// **'{used} GB / {total} GB'**
  String storagePs3HddUsage(String used, String total);

  /// No description provided for @trophyPioneerTitle.
  ///
  /// In en, this message translates to:
  /// **'OmniStation Pioneer'**
  String get trophyPioneerTitle;

  /// No description provided for @trophyPioneerDesc.
  ///
  /// In en, this message translates to:
  /// **'Booted the OmniStation multi-system emulator for the first time.'**
  String get trophyPioneerDesc;

  /// No description provided for @trophyVeteranTitle.
  ///
  /// In en, this message translates to:
  /// **'Hardware Veteran'**
  String get trophyVeteranTitle;

  /// No description provided for @trophyVeteranDesc.
  ///
  /// In en, this message translates to:
  /// **'Configured Metal 3 and Vulkan 1.3 zero-copy texture pipelines.'**
  String get trophyVeteranDesc;

  /// No description provided for @trophyCellMasterTitle.
  ///
  /// In en, this message translates to:
  /// **'Master of Cell Broadband Engine'**
  String get trophyCellMasterTitle;

  /// No description provided for @trophyCellMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Ran PowerPC PPE and 6 SPU worker threads concurrently with 0 jitter.'**
  String get trophyCellMasterDesc;

  /// No description provided for @trophyArchitectTitle.
  ///
  /// In en, this message translates to:
  /// **'Platinum Architect'**
  String get trophyArchitectTitle;

  /// No description provided for @trophyArchitectDesc.
  ///
  /// In en, this message translates to:
  /// **'Achieved 100% test coverage across C++23, Rust, and Flutter 3.x.'**
  String get trophyArchitectDesc;

  /// No description provided for @btnSelect.
  ///
  /// In en, this message translates to:
  /// **'SELECT'**
  String get btnSelect;

  /// No description provided for @btnStart.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get btnStart;

  /// No description provided for @btnL1.
  ///
  /// In en, this message translates to:
  /// **'L1'**
  String get btnL1;

  /// No description provided for @btnL2.
  ///
  /// In en, this message translates to:
  /// **'L2'**
  String get btnL2;

  /// No description provided for @btnR1.
  ///
  /// In en, this message translates to:
  /// **'R1'**
  String get btnR1;

  /// No description provided for @btnR2.
  ///
  /// In en, this message translates to:
  /// **'R2'**
  String get btnR2;

  /// No description provided for @errorPkgMissingRapSim.
  ///
  /// In en, this message translates to:
  /// **'EP0001-BLES00001_00.rap not found in exdata'**
  String get errorPkgMissingRapSim;

  /// No description provided for @defaultGameTitle.
  ///
  /// In en, this message translates to:
  /// **'OmniStation Game'**
  String get defaultGameTitle;

  /// No description provided for @actionImportGame.
  ///
  /// In en, this message translates to:
  /// **'Import Game'**
  String get actionImportGame;

  /// No description provided for @actionDeleteGame.
  ///
  /// In en, this message translates to:
  /// **'Delete Game'**
  String get actionDeleteGame;

  /// No description provided for @dialogDeleteGameConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this game from your library?'**
  String get dialogDeleteGameConfirm;

  /// No description provided for @msgGameImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Game imported successfully: {title}'**
  String msgGameImportSuccess(String title);

  /// No description provided for @msgGameImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to import game: {error}'**
  String msgGameImportFailed(String error);

  /// No description provided for @emptyLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'No Games Installed'**
  String get emptyLibraryTitle;

  /// No description provided for @emptyLibraryDesc.
  ///
  /// In en, this message translates to:
  /// **'Import ROMs or disc images (.smc, .sfc, .msc, .iso, .zip, .pkg, .bin, .pbp, .cso, .vpk, .wbfs, .rvz, .wud, .rpx) to begin playing.'**
  String get emptyLibraryDesc;

  /// No description provided for @storageTotalAppSpace.
  ///
  /// In en, this message translates to:
  /// **'Total Storage Used'**
  String get storageTotalAppSpace;

  /// No description provided for @storageGamesSpace.
  ///
  /// In en, this message translates to:
  /// **'Installed Games'**
  String get storageGamesSpace;

  /// No description provided for @storageSavesSpace.
  ///
  /// In en, this message translates to:
  /// **'Save States & SRAM'**
  String get storageSavesSpace;

  /// No description provided for @storageCardsSpace.
  ///
  /// In en, this message translates to:
  /// **'Virtual Memory Cards'**
  String get storageCardsSpace;

  /// No description provided for @storageFreeSpace.
  ///
  /// In en, this message translates to:
  /// **'Device Free Space'**
  String get storageFreeSpace;

  /// No description provided for @storageClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get storageClearCache;

  /// No description provided for @storageClearCacheSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully.'**
  String get storageClearCacheSuccess;

  /// No description provided for @emptyTrophiesTitle.
  ///
  /// In en, this message translates to:
  /// **'No Trophies Earned'**
  String get emptyTrophiesTitle;

  /// No description provided for @emptyTrophiesDesc.
  ///
  /// In en, this message translates to:
  /// **'Play games and complete in-game milestones to earn trophies.'**
  String get emptyTrophiesDesc;

  /// No description provided for @actionScanDirectory.
  ///
  /// In en, this message translates to:
  /// **'Scan Directory'**
  String get actionScanDirectory;

  /// No description provided for @unitGigabytes.
  ///
  /// In en, this message translates to:
  /// **'{value} GB'**
  String unitGigabytes(String value);

  /// No description provided for @unitMegabytes.
  ///
  /// In en, this message translates to:
  /// **'{value} MB'**
  String unitMegabytes(String value);

  /// No description provided for @unitKilobytes.
  ///
  /// In en, this message translates to:
  /// **'{value} KB'**
  String unitKilobytes(String value);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
