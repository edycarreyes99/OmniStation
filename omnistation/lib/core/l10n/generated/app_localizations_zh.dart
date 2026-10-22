// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'OmniStation';

  @override
  String get tagline => '高性能多系统模拟器';

  @override
  String get navLibrary => '游戏库';

  @override
  String get navStorage => '存储管理';

  @override
  String get navTrophies => '奖杯';

  @override
  String get navSettings => '设置';

  @override
  String get platformSnes => '超级任天堂 (SNES)';

  @override
  String get platformPs1 => 'PlayStation 1';

  @override
  String get platformPs2 => 'PlayStation 2';

  @override
  String get platformPs3 => 'PlayStation 3';

  @override
  String get statusReady => '就绪';

  @override
  String get statusRunning => '运行中';

  @override
  String get statusPaused => '已暂停';

  @override
  String get statusStopped => '已停止';

  @override
  String get statusCompilingShaders => '正在编译着色器...';

  @override
  String get statusBootingKernel => '正在启动内核...';

  @override
  String get statusLoadingDisc => '正在读取光盘...';

  @override
  String get telemetryFps => '帧率 (FPS)';

  @override
  String get telemetryFrameTime => '帧生成时间';

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
  String get actionPlay => '开始游戏';

  @override
  String get actionPause => '暂停';

  @override
  String get actionResume => '继续';

  @override
  String get actionStop => '停止';

  @override
  String get actionRestart => '重新开始';

  @override
  String get actionLoadState => '读取即时存档';

  @override
  String get actionSaveState => '保存即时存档';

  @override
  String get actionQuickMenu => '快捷菜单';

  @override
  String get actionInstallPkg => '安装 PKG/PUP';

  @override
  String get actionInsertDisc => '插入光盘';

  @override
  String get actionEjectDisc => '弹出光盘';

  @override
  String get storageMemoryCard => '记忆卡';

  @override
  String get storageMemoryCardSlot1 => '记忆卡插槽 1';

  @override
  String get storageMemoryCardSlot2 => '记忆卡插槽 2';

  @override
  String get storagePs3Hdd => 'PS3 虚拟硬盘';

  @override
  String storageBlocksFree(int count) {
    return '剩余 $count 个存储块';
  }

  @override
  String get storageFormat => '格式化记忆卡';

  @override
  String get storageFormatConfirm => '确定要格式化此记忆卡吗？所有保存的数据将被永久抹除。';

  @override
  String get storageFormatSuccess => '记忆卡格式化成功。';

  @override
  String get trophyUnlocked => '奖杯已解锁！';

  @override
  String get trophyBronze => '铜杯';

  @override
  String get trophySilver => '银杯';

  @override
  String get trophyGold => '金杯';

  @override
  String get trophyPlatinum => '白金杯';

  @override
  String get settingsGeneral => '通用';

  @override
  String get settingsGraphics => '图形';

  @override
  String get settingsAudio => '音频';

  @override
  String get settingsInput => '输入与手柄';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeLight => '浅色模式';

  @override
  String get settingsThemeDark => '深色模式';

  @override
  String get settingsThemeSystem => '跟随系统';

  @override
  String get settingsInternalResolution => '内部渲染分辨率缩放';

  @override
  String get settingsShaderPreset => '画面后处理滤镜';

  @override
  String get settingsShaderNone => '双线性过滤';

  @override
  String get settingsShaderCrt => 'CRT Royale 复古显像管';

  @override
  String get settingsShaderScanlines => '扫描线效果';

  @override
  String get errorTitle => '模拟器错误';

  @override
  String get errorUnknown => '模拟过程中发生未知错误。';

  @override
  String get errorDiscRead => '读取光盘镜像失败。文件可能已损坏或无法访问。';

  @override
  String get errorUdfFs => '解析蓝光 UDF 2.50 文件系统失败。';

  @override
  String get errorIsoDecryption => '检测到加密的 PS3 光盘。解密密钥 (.ird / .dkey) 缺失或无效。';

  @override
  String get errorParamSfo => '读取或解析 PARAM.SFO 元数据失败。';

  @override
  String get errorSelfDecryption => '解密 SELF/SPRX 二进制文件失败。SCE/NPDRM 签名验证未通过。';

  @override
  String get errorPkgRapMissing => '已安装的 PKG 包缺少对应的 .rap 授权许可证文件。';

  @override
  String get errorFirmwareMissing => '未找到所需的系统固件或 BIOS 文件。请先安装系统软件。';

  @override
  String get errorMemoryCardCorrupt => '记忆卡镜像已损坏或校验和验证失败。';

  @override
  String get errorPs3SaveDataSignature => 'PS3 存档数据验证失败（PARAM.PFD 数字签名损坏）。';

  @override
  String get errorSaveStateVersion => '即时存档版本与当前模拟核心不兼容。';

  @override
  String get errorAudioInit => '低延迟音频输出初始化失败。';

  @override
  String get errorGpuInit => '硬件 GPU 渲染器初始化失败。请检查 Vulkan/Metal 驱动支持。';

  @override
  String get errorJitAllocation => '分配 JIT 可执行代码内存缓存失败。';

  @override
  String get actionOk => '确定';

  @override
  String get actionCancel => '取消';

  @override
  String get filterAll => '全部主机';

  @override
  String get actionHideHud => '隐藏 HUD';

  @override
  String get actionShowHud => '显示 HUD';

  @override
  String get actionSimulateTrophy => '模拟奖杯解锁';

  @override
  String saveStateSuccess(int slot) {
    return '即时存档保存成功 (槽位 $slot)。';
  }

  @override
  String loadStateSuccess(int slot) {
    return '即时读档恢复成功 (槽位 $slot)。';
  }

  @override
  String get trophyGrandMaster => 'OmniStation 特级大师';

  @override
  String unitMilliseconds(String value) {
    return '$value 毫秒';
  }

  @override
  String percentFormat(int value) {
    return '$value%';
  }

  @override
  String get statusRtlActive => 'RTL 镜像已激活';

  @override
  String get tagRtl => '(RTL)';

  @override
  String get settingsGraphicsScaleDesc => 'Vulkan 1.3 / Metal 3 硬件分辨率缩放';

  @override
  String get settingsResNative => '1x 原生';

  @override
  String get settingsRes1440p => '2x (1440p 2K高清)';

  @override
  String get settingsRes4k => '4x (4K 超高清)';

  @override
  String get settingsRes8k => '8x (8K 极限)';

  @override
  String get settingsShaderDesc => 'Impeller 实时后处理着色器管线';

  @override
  String get storagePs1Capacity => 'PlayStation 1 (128 KB)';

  @override
  String get storagePs2Capacity => 'PlayStation 2 (8 MB)';

  @override
  String get storagePfdValid => 'PARAM.PFD 签名有效';

  @override
  String get storagePs3HddPath => 'dev_hdd0/home/00000001/savedata';

  @override
  String storagePs3HddUsage(String used, String total) {
    return '$used GB / $total GB';
  }

  @override
  String get trophyPioneerTitle => 'OmniStation 开拓者';

  @override
  String get trophyPioneerDesc => '首次启动 OmniStation 多系统模拟器。';

  @override
  String get trophyVeteranTitle => '硬件老兵';

  @override
  String get trophyVeteranDesc => '成功配置 Metal 3 与 Vulkan 1.3 零拷贝纹理渲染通道。';

  @override
  String get trophyCellMasterTitle => 'Cell 宽带引擎大师';

  @override
  String get trophyCellMasterDesc => '同时无延迟运行 PowerPC PPE 与 6 个 SPU 协同线程。';

  @override
  String get trophyArchitectTitle => '白金架构师';

  @override
  String get trophyArchitectDesc => '在 C++23、Rust 与 Flutter 3.x 实现 100% 测试覆盖率。';

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
  String get errorPkgMissingRapSim => '在 exdata 中未找到 EP0001-BLES00001_00.rap';

  @override
  String get defaultGameTitle => 'OmniStation 游戏';

  @override
  String get actionImportGame => '导入游戏';

  @override
  String get actionDeleteGame => '删除游戏';

  @override
  String get dialogDeleteGameConfirm => '您确定要从游戏库中删除此游戏吗？';

  @override
  String msgGameImportSuccess(String title) {
    return '游戏导入成功：$title';
  }

  @override
  String msgGameImportFailed(String error) {
    return '导入游戏失败：$error';
  }

  @override
  String get emptyLibraryTitle => '未安装游戏';

  @override
  String get emptyLibraryDesc =>
      '导入 ROM 或光盘镜像（.smc、.sfc、.msc、.iso、.zip、.pkg、.bin）开始游玩。';

  @override
  String get storageTotalAppSpace => '已用总存储空间';

  @override
  String get storageGamesSpace => '已安装游戏';

  @override
  String get storageSavesSpace => '存档与 SRAM';

  @override
  String get storageCardsSpace => '虚拟记忆卡';

  @override
  String get storageFreeSpace => '设备剩余空间';

  @override
  String get storageClearCache => '清除缓存';

  @override
  String get storageClearCacheSuccess => '缓存已成功清除。';

  @override
  String get emptyTrophiesTitle => '尚未获得奖杯';

  @override
  String get emptyTrophiesDesc => '游玩游戏并达成游戏内里程碑以赢取奖杯。';

  @override
  String get actionScanDirectory => '扫描文件夹';

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
