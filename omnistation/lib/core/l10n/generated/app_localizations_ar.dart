// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'أومني ستيشن';

  @override
  String get tagline => 'محاكي متعدد الأنظمة فائق الأداء';

  @override
  String get navLibrary => 'المكتبة';

  @override
  String get navStorage => 'وحدة التخزين';

  @override
  String get navTrophies => 'الجوائز';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get platformSnes => 'سوبر نينتندو';

  @override
  String get platformPs1 => 'بلاي ستيشن 1';

  @override
  String get platformPs2 => 'بلاي ستيشن 2';

  @override
  String get platformPs3 => 'بلاي ستيشن 3';

  @override
  String get statusReady => 'جاهز';

  @override
  String get statusRunning => 'قيد التشغيل';

  @override
  String get statusPaused => 'متوقف مؤقتاً';

  @override
  String get statusStopped => 'متوقف';

  @override
  String get statusCompilingShaders => 'جاري تجميع التظليل...';

  @override
  String get statusBootingKernel => 'جاري تشغيل النواة...';

  @override
  String get statusLoadingDisc => 'جاري تحميل القرص...';

  @override
  String get telemetryFps => 'إطار/ث';

  @override
  String get telemetryFrameTime => 'زمن الإطار';

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
  String get actionPlay => 'تشغيل';

  @override
  String get actionPause => 'إيقاف مؤقت';

  @override
  String get actionResume => 'استئناف';

  @override
  String get actionStop => 'إيقاف';

  @override
  String get actionRestart => 'إعادة التشغيل';

  @override
  String get actionLoadState => 'تحميل الحالة';

  @override
  String get actionSaveState => 'حفظ الحالة';

  @override
  String get actionQuickMenu => 'القائمة السريعة';

  @override
  String get actionInstallPkg => 'تثبيت PKG/PUP';

  @override
  String get actionInsertDisc => 'إدخال القرص';

  @override
  String get actionEjectDisc => 'إخراج القرص';

  @override
  String get storageMemoryCard => 'بطاقة الذاكرة';

  @override
  String get storageMemoryCardSlot1 => 'بطاقة الذاكرة المنفذ 1';

  @override
  String get storageMemoryCardSlot2 => 'بطاقة الذاكرة المنفذ 2';

  @override
  String get storagePs3Hdd => 'قرص PS3 الافتراضي';

  @override
  String storageBlocksFree(int count) {
    return '$count كتل فارغة';
  }

  @override
  String get storageFormat => 'تهيأة البطاقة';

  @override
  String get storageFormatConfirm =>
      'هل أنت متأكد من رغبتك في تهيئة بطاقة الذاكرة؟ سيتم مسح جميع بيانات الحفظ نهائياً.';

  @override
  String get storageFormatSuccess => 'تمت تهيئة بطاقة الذاكرة بنجاح.';

  @override
  String get trophyUnlocked => 'تم فتح الجائزة!';

  @override
  String get trophyBronze => 'برونزية';

  @override
  String get trophySilver => 'فضية';

  @override
  String get trophyGold => 'ذهبية';

  @override
  String get trophyPlatinum => 'بلاتينية';

  @override
  String get settingsGeneral => 'عام';

  @override
  String get settingsGraphics => 'الرسومات';

  @override
  String get settingsAudio => 'الصوت';

  @override
  String get settingsInput => 'الإدخال وأجهزة التحكم';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsTheme => 'المظهر';

  @override
  String get settingsThemeLight => 'الوضع الفاتح';

  @override
  String get settingsThemeDark => 'الوضع الداكن';

  @override
  String get settingsThemeSystem => 'افتراضي النظام';

  @override
  String get settingsInternalResolution => 'مقياس الدقة الداخلية';

  @override
  String get settingsShaderPreset => 'مرشح ما بعد المعالجة';

  @override
  String get settingsShaderNone => 'خطي ثنائي';

  @override
  String get settingsShaderCrt => 'أنبوب CRT Royale';

  @override
  String get settingsShaderScanlines => 'خطوط المسح';

  @override
  String get errorTitle => 'خطأ في المحاكاة';

  @override
  String get errorUnknown => 'حدث خطأ غير متوقع أثناء المحاكاة.';

  @override
  String get errorDiscRead =>
      'فشل في قراءة صورة القرص. قد يكون الملف تالفاً أو لا يمكن الوصول إليه.';

  @override
  String get errorUdfFs => 'فشل تحليل نظام ملفات Blu-ray UDF 2.50.';

  @override
  String get errorIsoDecryption =>
      'تم اكتشاف قرص PS3 مشفر. مفتاح فك التشفير مفقود أو غير صالح (.ird / .dkey).';

  @override
  String get errorParamSfo => 'فشل في قراءة أو تحليل بيانات PARAM.SFO.';

  @override
  String get errorSelfDecryption =>
      'فشل فك تشفير ملف SELF/SPRX الثنائي. فشل التحقق من توقيع SCE/NPDRM.';

  @override
  String get errorPkgRapMissing => 'ملف ترخيص .rap مفقود لحزمة PKG المثبتة.';

  @override
  String get errorFirmwareMissing =>
      'لم يتم العثور على البرنامج الثابت أو ملف BIOS المطلوب. يرجى تثبيت برامج النظام.';

  @override
  String get errorMemoryCardCorrupt =>
      'صورة بطاقة الذاكرة تالفة أو فشل التحقق من المجموع الاختباري.';

  @override
  String get errorPs3SaveDataSignature =>
      'فشل التحقق من بيانات حفظ PS3 (توقيع PARAM.PFD تالف).';

  @override
  String get errorSaveStateVersion =>
      'إصدار حالة الحفظ غير متوافق مع هذا الإصدار من المحاكي.';

  @override
  String get errorAudioInit => 'فشل في تهيئة مخرج الصوت منخفض التأخير.';

  @override
  String get errorGpuInit =>
      'فشل في تهيئة معالج الرسومات. يرجى التحقق من دعم Vulkan/Metal.';

  @override
  String get errorJitAllocation =>
      'فشل تخصيص ذاكرة تخزين مؤقت لرموز JIT القابلة للتنفيذ.';

  @override
  String get actionOk => 'موافق';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get filterAll => 'جميع الأجهزة';

  @override
  String get actionHideHud => 'إخفاء لوحة المعلومات';

  @override
  String get actionShowHud => 'إظهار لوحة المعلومات';

  @override
  String get actionSimulateTrophy => 'محاكاة فتح الإنجاز';

  @override
  String saveStateSuccess(int slot) {
    return 'تم حفظ الحالة بنجاح (الموضع $slot).';
  }

  @override
  String loadStateSuccess(int slot) {
    return 'تم استرجاع الحالة بنجاح (الموضع $slot).';
  }

  @override
  String get trophyGrandMaster => 'الأستاذ الأكبر لـ OmniStation';

  @override
  String unitMilliseconds(String value) {
    return '$value مللي ثانية';
  }

  @override
  String percentFormat(int value) {
    return '$value٪';
  }

  @override
  String get statusRtlActive => 'RTL مفعّل';

  @override
  String get tagRtl => '(RTL)';

  @override
  String get settingsGraphicsScaleDesc =>
      'مُرقّي الدقة الرسومية بالعتاد Vulkan 1.3 / Metal 3';

  @override
  String get settingsResNative => '1x الدقة الأصلية';

  @override
  String get settingsRes1440p => '2x (1440p دقة عالية)';

  @override
  String get settingsRes4k => '4x (4K دقة فائقة)';

  @override
  String get settingsRes8k => '8x (8K دقة خارقة)';

  @override
  String get settingsShaderDesc => 'مسار التظليل بالوقت الفعلي Impeller';

  @override
  String get storagePs1Capacity => 'PlayStation 1 (128 كيلوبايت)';

  @override
  String get storagePs2Capacity => 'PlayStation 2 (8 ميجابايت)';

  @override
  String get storagePfdValid => 'توقيع PARAM.PFD سليم';

  @override
  String get storagePs3HddPath => 'dev_hdd0/home/00000001/savedata';

  @override
  String storagePs3HddUsage(String used, String total) {
    return '$used جيجابايت / $total جيجابايت';
  }

  @override
  String get trophyPioneerTitle => 'رائد OmniStation';

  @override
  String get trophyPioneerDesc =>
      'تم تشغيل محاكي الأنظمة المتعددة OmniStation لأول مرة.';

  @override
  String get trophyVeteranTitle => 'خبير العتاد';

  @override
  String get trophyVeteranDesc =>
      'تم تكوين مسارات إكساء Metal 3 وVulkan 1.3 بدون نسخ للذاكرة.';

  @override
  String get trophyCellMasterTitle => 'أستاذ محرك Cell Broadband';

  @override
  String get trophyCellMasterDesc =>
      'تم تشغيل PPE PowerPC و6 خيوط SPU بالتوازي وبدون أي تأخير.';

  @override
  String get trophyArchitectTitle => 'المهندس البلاتيني';

  @override
  String get trophyArchitectDesc =>
      'تم تحقيق تغطية اختبار 100% عبر C++23 وRust وFlutter 3.x.';

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
      'ملف EP0001-BLES00001_00.rap غير موجود في exdata';

  @override
  String get defaultGameTitle => 'لعبة OmniStation';

  @override
  String get actionImportGame => 'استيراد لعبة';

  @override
  String get actionDeleteGame => 'حذف اللعبة';

  @override
  String get dialogDeleteGameConfirm =>
      'هل أنت متأكد من رغبتك في إزالة هذه اللعبة من مكتبتك؟';

  @override
  String msgGameImportSuccess(String title) {
    return 'تم استيراد اللعبة بنجاح: $title';
  }

  @override
  String msgGameImportFailed(String error) {
    return 'فشل استيراد اللعبة: $error';
  }

  @override
  String get emptyLibraryTitle => 'لا توجد ألعاب مثبتة';

  @override
  String get emptyLibraryDesc =>
      'استورد ملفات ROM أو صور الأقراص (.smc، .sfc، .msc، .iso، .zip، .pkg، .bin) لبدء اللعب.';

  @override
  String get storageTotalAppSpace => 'إجمالي المساحة المستخدمة';

  @override
  String get storageGamesSpace => 'الألعاب المثبتة';

  @override
  String get storageSavesSpace => 'حالات الحفظ و SRAM';

  @override
  String get storageCardsSpace => 'بطاقات الذاكرة الافتراضية';

  @override
  String get storageFreeSpace => 'المساحة الخالية بالجهاز';

  @override
  String get storageClearCache => 'مسح ذاكرة التخزين المؤقت';

  @override
  String get storageClearCacheSuccess => 'تم مسح ذاكرة التخزين المؤقت بنجاح.';

  @override
  String get emptyTrophiesTitle => 'لم يتم الحصول على كؤوس';

  @override
  String get emptyTrophiesDesc => 'العب الألعاب وحقق الإنجازات لفتح الكؤوس.';

  @override
  String get actionScanDirectory => 'فحص المجلد';

  @override
  String unitGigabytes(String value) {
    return '$value جيجابايت';
  }

  @override
  String unitMegabytes(String value) {
    return '$value ميجابايت';
  }

  @override
  String unitKilobytes(String value) {
    return '$value كيلوبايت';
  }
}
