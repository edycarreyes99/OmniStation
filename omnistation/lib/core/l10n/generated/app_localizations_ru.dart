// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'OmniStation';

  @override
  String get tagline => 'Высокопроизводительный мультисистемный эмулятор';

  @override
  String get navLibrary => 'Библиотека';

  @override
  String get navStorage => 'Память';

  @override
  String get navTrophies => 'Призы';

  @override
  String get navSettings => 'Настройки';

  @override
  String get platformSnes => 'Super Nintendo';

  @override
  String get platformPs1 => 'PlayStation 1';

  @override
  String get platformPs2 => 'PlayStation 2';

  @override
  String get platformPs3 => 'PlayStation 3';

  @override
  String get statusReady => 'Готов';

  @override
  String get statusRunning => 'Выполняется';

  @override
  String get statusPaused => 'Приостановлено';

  @override
  String get statusStopped => 'Остановлено';

  @override
  String get statusCompilingShaders => 'Компиляция шейдеров...';

  @override
  String get statusBootingKernel => 'Загрузка ядра...';

  @override
  String get statusLoadingDisc => 'Чтение оптического диска...';

  @override
  String get telemetryFps => 'FPS';

  @override
  String get telemetryFrameTime => 'Время кадра';

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
  String get actionPlay => 'Играть';

  @override
  String get actionPause => 'Пауза';

  @override
  String get actionResume => 'Продолжить';

  @override
  String get actionStop => 'Стоп';

  @override
  String get actionRestart => 'Перезапустить';

  @override
  String get actionLoadState => 'Загрузить состояние';

  @override
  String get actionSaveState => 'Сохранить состояние';

  @override
  String get actionQuickMenu => 'Быстрое меню';

  @override
  String get actionInstallPkg => 'Установить PKG/PUP';

  @override
  String get actionInsertDisc => 'Вставить диск';

  @override
  String get actionEjectDisc => 'Извлечь диск';

  @override
  String get storageMemoryCard => 'Карта памяти';

  @override
  String get storageMemoryCardSlot1 => 'Карта памяти Слот 1';

  @override
  String get storageMemoryCardSlot2 => 'Карта памяти Слот 2';

  @override
  String get storagePs3Hdd => 'Виртуальный диск PS3';

  @override
  String storageBlocksFree(int count) {
    return 'Свободно $count блоков';
  }

  @override
  String get storageFormat => 'Форматировать карту';

  @override
  String get storageFormatConfirm =>
      'Вы уверены, что хотите отформатировать карту памяти? Все сохраненные данные будут безвозвратно удалены.';

  @override
  String get storageFormatSuccess => 'Карта памяти успешно отформатирована.';

  @override
  String get trophyUnlocked => 'Приз получен!';

  @override
  String get trophyBronze => 'Бронза';

  @override
  String get trophySilver => 'Серебро';

  @override
  String get trophyGold => 'Золото';

  @override
  String get trophyPlatinum => 'Платина';

  @override
  String get settingsGeneral => 'Общие';

  @override
  String get settingsGraphics => 'Графика';

  @override
  String get settingsAudio => 'Аудио';

  @override
  String get settingsInput => 'Ввод и геймпады';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeLight => 'Светлая тема';

  @override
  String get settingsThemeDark => 'Темная тема';

  @override
  String get settingsThemeSystem => 'Системная';

  @override
  String get settingsInternalResolution => 'Масштабирование разрешения';

  @override
  String get settingsShaderPreset => 'Фильтр постобработки';

  @override
  String get settingsShaderNone => 'Билинейный';

  @override
  String get settingsShaderCrt => 'CRT Royale ЭЛТ';

  @override
  String get settingsShaderScanlines => 'Сканлайны';

  @override
  String get errorTitle => 'Ошибка эмуляции';

  @override
  String get errorUnknown =>
      'Во время эмуляции произошла непредвиденная ошибка.';

  @override
  String get errorDiscRead =>
      'Не удалось прочитать образ оптического диска. Файл поврежден или недоступен.';

  @override
  String get errorUdfFs =>
      'Ошибка синтаксического анализа файловой системы Blu-ray UDF 2.50.';

  @override
  String get errorIsoDecryption =>
      'Обнаружен зашифрованный диск PS3. Ключ (.ird / .dkey) отсутствует или недействителен.';

  @override
  String get errorParamSfo =>
      'Не удалось прочитать или обработать метаданные PARAM.SFO.';

  @override
  String get errorSelfDecryption =>
      'Не удалось расшифровать бинарный файл SELF/SPRX. Ошибка проверки подписи SCE/NPDRM.';

  @override
  String get errorPkgRapMissing =>
      'Отсутствует файл лицензии .rap для установленного пакета PKG.';

  @override
  String get errorFirmwareMissing =>
      'Необходимый файл прошивки или BIOS не найден. Установите системное ПО.';

  @override
  String get errorMemoryCardCorrupt =>
      'Образ карты памяти поврежден или не прошел проверку контрольной суммы.';

  @override
  String get errorPs3SaveDataSignature =>
      'Ошибка проверки сохранения PS3 (повреждена подпись PARAM.PFD).';

  @override
  String get errorSaveStateVersion =>
      'Версия файла сохранения несовместима с текущим ядром эмулятора.';

  @override
  String get errorAudioInit =>
      'Не удалось инициализировать аудиоустройство с низкой задержкой.';

  @override
  String get errorGpuInit =>
      'Сбой инициализации аппаратного рендерера GPU. Проверьте поддержку Vulkan/Metal.';

  @override
  String get errorJitAllocation =>
      'Не удалось выделить память под исполняемый кэш JIT-кода.';

  @override
  String get actionOk => 'ОК';

  @override
  String get actionCancel => 'Отмена';

  @override
  String get filterAll => 'Все консоли';

  @override
  String get actionHideHud => 'Скрыть HUD';

  @override
  String get actionShowHud => 'Показать HUD';

  @override
  String get actionSimulateTrophy => 'Симулировать разблокировку трофея';

  @override
  String saveStateSuccess(int slot) {
    return 'Состояние успешно сохранено (Слот $slot).';
  }

  @override
  String loadStateSuccess(int slot) {
    return 'Состояние успешно загружено (Слот $slot).';
  }

  @override
  String get trophyGrandMaster => 'Гроссмейстер OmniStation';

  @override
  String unitMilliseconds(String value) {
    return '$value мс';
  }

  @override
  String percentFormat(int value) {
    return '$value%';
  }

  @override
  String get statusRtlActive => 'RTL Активен';

  @override
  String get tagRtl => '(RTL)';

  @override
  String get settingsGraphicsScaleDesc =>
      'Аппаратное масштабирование Vulkan 1.3 / Metal 3';

  @override
  String get settingsResNative => '1x Исходное';

  @override
  String get settingsRes1440p => '2x (1440p Quad HD)';

  @override
  String get settingsRes4k => '4x (4K Ultra HD)';

  @override
  String get settingsRes8k => '8x (8K Экстрим)';

  @override
  String get settingsShaderDesc =>
      'Конвейер шейдеров реального времени Impeller';

  @override
  String get storagePs1Capacity => 'PlayStation 1 (128 КБ)';

  @override
  String get storagePs2Capacity => 'PlayStation 2 (8 МБ)';

  @override
  String get storagePfdValid => 'Подпись PARAM.PFD верна';

  @override
  String get storagePs3HddPath => 'dev_hdd0/home/00000001/savedata';

  @override
  String storagePs3HddUsage(String used, String total) {
    return '$used ГБ / $total ГБ';
  }

  @override
  String get trophyPioneerTitle => 'Первопроходец OmniStation';

  @override
  String get trophyPioneerDesc =>
      'Мультисистемный эмулятор OmniStation запущен впервые.';

  @override
  String get trophyVeteranTitle => 'Ветеран аппаратного обеспечения';

  @override
  String get trophyVeteranDesc =>
      'Настроены конвейеры текстур Metal 3 и Vulkan 1.3 без копирования в памяти.';

  @override
  String get trophyCellMasterTitle => 'Мастер Cell Broadband Engine';

  @override
  String get trophyCellMasterDesc =>
      'PowerPC PPE и 6 потоков SPU запущены параллельно без задержек.';

  @override
  String get trophyArchitectTitle => 'Платиновый архитектор';

  @override
  String get trophyArchitectDesc =>
      'Достигнуто 100% тестовое покрытие в C++23, Rust и Flutter 3.x.';

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
      'Файл EP0001-BLES00001_00.rap не найден в exdata';

  @override
  String get defaultGameTitle => 'Игра OmniStation';

  @override
  String get actionImportGame => 'Импортировать игру';

  @override
  String get actionDeleteGame => 'Удалить игру';

  @override
  String get dialogDeleteGameConfirm =>
      'Вы уверены, что хотите удалить эту игру из библиотеки?';

  @override
  String msgGameImportSuccess(String title) {
    return 'Игра успешно импортирована: $title';
  }

  @override
  String msgGameImportFailed(String error) {
    return 'Не удалось импортировать игру: $error';
  }

  @override
  String get emptyLibraryTitle => 'Нет установленных игр';

  @override
  String get emptyLibraryDesc =>
      'Импортируйте ROM или образы дисков (.smc, .sfc, .msc, .iso, .zip, .pkg, .bin), чтобы начать игру.';

  @override
  String get storageTotalAppSpace => 'Всего занято памяти';

  @override
  String get storageGamesSpace => 'Установленные игры';

  @override
  String get storageSavesSpace => 'Сохранения и SRAM';

  @override
  String get storageCardsSpace => 'Виртуальные карты памяти';

  @override
  String get storageFreeSpace => 'Свободно на устройстве';

  @override
  String get storageClearCache => 'Очистить кэш';

  @override
  String get storageClearCacheSuccess => 'Кэш успешно очищен.';

  @override
  String get emptyTrophiesTitle => 'Нет полученных трофеев';

  @override
  String get emptyTrophiesDesc =>
      'Играйте в игры и достигайте целей, чтобы получать трофеи.';

  @override
  String get actionScanDirectory => 'Сканировать папку';

  @override
  String unitGigabytes(String value) {
    return '$value ГБ';
  }

  @override
  String unitMegabytes(String value) {
    return '$value МБ';
  }

  @override
  String unitKilobytes(String value) {
    return '$value КБ';
  }
}
