// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'ओम्नीस्टेशन';

  @override
  String get tagline => 'उच्च-प्रदर्शन मल्टी-सिस्टम एमुलेटर';

  @override
  String get navLibrary => 'लाइब्रेरी';

  @override
  String get navStorage => 'स्टोरेज';

  @override
  String get navTrophies => 'ट्रॉफ़ी';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get platformSnes => 'सुपर निंटेंडो';

  @override
  String get platformPs1 => 'प्लेस्टेशन 1';

  @override
  String get platformPs2 => 'प्लेस्टेशन 2';

  @override
  String get platformPs3 => 'प्लेस्टेशन 3';

  @override
  String get platformPsp => 'प्लेस्टेशन पोर्टेबल';

  @override
  String get platformPsVita => 'प्लेस्टेशन वीटा';

  @override
  String get platformWii => 'निंटेंडो वी';

  @override
  String get platformWiiU => 'निंटेंडो वी यू';

  @override
  String get statusReady => 'तैयार';

  @override
  String get statusRunning => 'चालू है';

  @override
  String get statusPaused => 'रोका गया';

  @override
  String get statusStopped => 'बंद किया गया';

  @override
  String get statusCompilingShaders => 'शेडर्स संकलित किए जा रहे हैं...';

  @override
  String get statusBootingKernel => 'कर्नेल बूट हो रहा है...';

  @override
  String get statusLoadingDisc => 'डिस्क लोड हो रही है...';

  @override
  String get telemetryFps => 'FPS';

  @override
  String get telemetryFrameTime => 'फ़्रेम समय';

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
  String get actionPlay => 'खेलें';

  @override
  String get actionPause => 'रोकें';

  @override
  String get actionResume => 'फिर से शुरू करें';

  @override
  String get actionStop => 'रोकें';

  @override
  String get actionRestart => 'पुनरारंभ करें';

  @override
  String get actionLoadState => 'स्टेट लोड करें';

  @override
  String get actionSaveState => 'स्टेट सहेजें';

  @override
  String get actionQuickMenu => 'त्वरित मेनू';

  @override
  String get actionInstallPkg => 'PKG/PUP इंस्टॉल करें';

  @override
  String get actionInsertDisc => 'डिस्क डालें';

  @override
  String get actionEjectDisc => 'डिस्क निकालें';

  @override
  String get storageMemoryCard => 'मेमोरी कार्ड';

  @override
  String get storageMemoryCardSlot1 => 'मेमोरी कार्ड स्लॉट 1';

  @override
  String get storageMemoryCardSlot2 => 'मेमोरी कार्ड स्लॉट 2';

  @override
  String get storagePs3Hdd => 'PS3 वर्चुअल HDD';

  @override
  String storageBlocksFree(int count) {
    return '$count ब्लॉक खाली हैं';
  }

  @override
  String get storageFormat => 'कार्ड प्रारूपित करें';

  @override
  String get storageFormatConfirm =>
      'क्या आप वाकई इस मेमोरी कार्ड को प्रारूपित करना चाहते हैं? सभी सहेजा गया डेटा स्थायी रूप से हटा दिया जाएगा।';

  @override
  String get storageFormatSuccess =>
      'मेमोरी कार्ड सफलतापूर्वक प्रारूपित किया गया।';

  @override
  String get trophyUnlocked => 'ट्रॉफ़ी अनलॉक हो गई!';

  @override
  String get trophyBronze => 'कांस्य';

  @override
  String get trophySilver => 'रजत';

  @override
  String get trophyGold => 'स्वर्ण';

  @override
  String get trophyPlatinum => 'प्लैटिनम';

  @override
  String get settingsGeneral => 'सामान्य';

  @override
  String get settingsGraphics => 'ग्राफ़िक्स';

  @override
  String get settingsAudio => 'ऑडियो';

  @override
  String get settingsInput => 'इनपुट और नियंत्रक';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsTheme => 'थीम';

  @override
  String get settingsThemeLight => 'लाइट मोड';

  @override
  String get settingsThemeDark => 'डार्क मोड';

  @override
  String get settingsThemeSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get settingsInternalResolution => 'आंतरिक रिज़ॉल्यूशन स्केलिंग';

  @override
  String get settingsShaderPreset => 'पोस्ट-प्रोसेसिंग फ़िल्टर';

  @override
  String get settingsShaderNone => 'बिलिनियर';

  @override
  String get settingsShaderCrt => 'CRT Royale';

  @override
  String get settingsShaderScanlines => 'स्कैनलाइन्स';

  @override
  String get errorTitle => 'एमुलेशन त्रुटि';

  @override
  String get errorUnknown =>
      'एमुलेशन के दौरान एक अप्रत्याशित त्रुटि उत्पन्न हुई।';

  @override
  String get errorDiscRead =>
      'ऑप्टिकल डिस्क छवि पढ़ने में विफल। फ़ाइल दूषित या पहुंच योग्य नहीं हो सकती है।';

  @override
  String get errorUdfFs =>
      'ब्लू-रे UDF 2.50 फ़ाइल सिस्टम को पार्स करने में विफल।';

  @override
  String get errorIsoDecryption =>
      'एन्क्रिप्टेड PS3 डिस्क का पता चला। डिक्रिप्शन कुंजी (.ird / .dkey) गायब या अमान्य है।';

  @override
  String get errorParamSfo =>
      'PARAM.SFO मेटाडेटा पढ़ने या पार्स करने में विफल।';

  @override
  String get errorSelfDecryption =>
      'SELF/SPRX बाइनरी को डिक्रिप्ट करने में विफल। SCE/NPDRM हस्ताक्षर सत्यापन विफल रहा।';

  @override
  String get errorPkgRapMissing =>
      'इंस्टॉल किए गए PKG पैकेज के लिए .rap लाइसेंस फ़ाइल गायब है।';

  @override
  String get errorFirmwareMissing =>
      'आवश्यक फर्मवेयर या BIOS फ़ाइल नहीं मिली। कृपया सिस्टम सॉफ़्टवेयर इंस्टॉल करें।';

  @override
  String get errorMemoryCardCorrupt =>
      'मेमोरी कार्ड छवि दूषित है या चेकसम सत्यापन विफल रहा।';

  @override
  String get errorPs3SaveDataSignature =>
      'PS3 सहेजें डेटा सत्यापन विफल रहा (PARAM.PFD हस्ताक्षर दूषित)।';

  @override
  String get errorSaveStateVersion =>
      'सहेजें स्थिति संस्करण इस कोर के साथ असंगत है।';

  @override
  String get errorAudioInit => 'कम विलंबता ऑडियो आउटपुट प्रारंभ करने में विफल।';

  @override
  String get errorGpuInit =>
      'हार्डवेयर GPU रेंडरर प्रारंभ करने में विफल रहा। Vulkan/Metal संगतता जांचें।';

  @override
  String get errorJitAllocation =>
      'निष्पादन योग्य JIT कोड कैश मेमोरी आवंटित करने में विफल।';

  @override
  String get actionOk => 'ठीक है';

  @override
  String get actionCancel => 'रद्द करें';

  @override
  String get filterAll => 'सभी कंसोल';

  @override
  String get actionHideHud => 'HUD छिपाएं';

  @override
  String get actionShowHud => 'HUD दिखाएं';

  @override
  String get actionSimulateTrophy => 'ट्रॉफी अनलॉक का अनुकरण करें';

  @override
  String saveStateSuccess(int slot) {
    return 'सेव स्टेट सफलतापूर्वक पूरा हुआ (स्लॉट $slot)।';
  }

  @override
  String loadStateSuccess(int slot) {
    return 'लोड स्टेट सफलतापूर्वक पुनर्स्थापित हुआ (स्लॉट $slot)।';
  }

  @override
  String get trophyGrandMaster => 'OmniStation ग्रैंड मास्टर';

  @override
  String unitMilliseconds(String value) {
    return '$value मिलीसेकंड';
  }

  @override
  String percentFormat(int value) {
    return '$value%';
  }

  @override
  String get statusRtlActive => 'RTL सक्रिय';

  @override
  String get tagRtl => '(RTL)';

  @override
  String get settingsGraphicsScaleDesc =>
      'Vulkan 1.3 / Metal 3 हार्डवेयर स्केलर';

  @override
  String get settingsResNative => '1x मूल';

  @override
  String get settingsRes1440p => '2x (1440p क्वाड एचडी)';

  @override
  String get settingsRes4k => '4x (4K अल्ट्रा एचडी)';

  @override
  String get settingsRes8k => '8x (8K एक्सट्रीम)';

  @override
  String get settingsShaderDesc => 'Impeller रियल-टाइम शेडर पाइपलाइन';

  @override
  String get storagePs1Capacity => 'PlayStation 1 (128 KB)';

  @override
  String get storagePs2Capacity => 'PlayStation 2 (8 MB)';

  @override
  String get storagePfdValid => 'PARAM.PFD वैध है';

  @override
  String get storagePs3HddPath => 'dev_hdd0/home/00000001/savedata';

  @override
  String storagePs3HddUsage(String used, String total) {
    return '$used GB / $total GB';
  }

  @override
  String get trophyPioneerTitle => 'OmniStation पायनियर';

  @override
  String get trophyPioneerDesc =>
      'OmniStation मल्टी-सिस्टम एमुलेटर पहली बार चालू किया गया।';

  @override
  String get trophyVeteranTitle => 'हार्डवेयर वयोवृद्ध';

  @override
  String get trophyVeteranDesc =>
      'Metal 3 और Vulkan 1.3 ज़ीरो-कॉपी टेक्सचर पाइपलाइन कॉन्फ़िगर की गईं।';

  @override
  String get trophyCellMasterTitle => 'सेल ब्रॉडबैंड इंजन के उस्ताद';

  @override
  String get trophyCellMasterDesc =>
      'PowerPC PPE और 6 SPU थ्रेड्स बिना किसी अंतराल के एक साथ चलाए गए।';

  @override
  String get trophyArchitectTitle => 'प्लैटिनम वास्तुकार';

  @override
  String get trophyArchitectDesc =>
      'C++23, Rust, और Flutter 3.x में 100% परीक्षण कवरेज हासिल किया।';

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
      'exdata में EP0001-BLES00001_00.rap नहीं मिला';

  @override
  String get defaultGameTitle => 'OmniStation गेम';

  @override
  String get actionImportGame => 'गेम आयात करें';

  @override
  String get actionDeleteGame => 'गेम हटाएं';

  @override
  String get dialogDeleteGameConfirm =>
      'क्या आप वाकई इस गेम को अपनी लाइब्रेरी से हटाना चाहते हैं?';

  @override
  String msgGameImportSuccess(String title) {
    return 'गेम सफलतापूर्वक आयात किया गया: $title';
  }

  @override
  String msgGameImportFailed(String error) {
    return 'गेम आयात विफल रहा: $error';
  }

  @override
  String get emptyLibraryTitle => 'कोई गेम इंस्टॉल नहीं है';

  @override
  String get emptyLibraryDesc =>
      'खेलना शुरू करने के लिए ROM या डिस्क इमेज (.smc, .sfc, .msc, .iso, .zip, .pkg, .bin) आयात करें।';

  @override
  String get storageTotalAppSpace => 'कुल उपयोग किया गया संग्रहण';

  @override
  String get storageGamesSpace => 'इंस्टॉल किए गए गेम';

  @override
  String get storageSavesSpace => 'सहेजे गए डेटा और SRAM';

  @override
  String get storageCardsSpace => 'वर्चुअल मेमोरी कार्ड';

  @override
  String get storageFreeSpace => 'डिवाइस में खाली स्थान';

  @override
  String get storageClearCache => 'कैश साफ़ करें';

  @override
  String get storageClearCacheSuccess => 'कैश सफलतापूर्वक साफ़ किया गया।';

  @override
  String get emptyTrophiesTitle => 'कोई ट्रॉफी अर्जित नहीं की गई';

  @override
  String get emptyTrophiesDesc =>
      'ट्रॉफी जीतने के लिए गेम खेलें और मील के पत्थर पूरे करें।';

  @override
  String get actionScanDirectory => 'फ़ोल्डर स्कैन करें';

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
