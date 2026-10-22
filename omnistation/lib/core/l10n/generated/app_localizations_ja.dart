// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'OmniStation';

  @override
  String get tagline => '超高性能マルチシステムエミュレータ';

  @override
  String get navLibrary => 'ライブラリ';

  @override
  String get navStorage => 'ストレージ';

  @override
  String get navTrophies => 'トロフィー';

  @override
  String get navSettings => '設定';

  @override
  String get platformSnes => 'スーパーファミコン (SNES)';

  @override
  String get platformPs1 => 'PlayStation 1';

  @override
  String get platformPs2 => 'PlayStation 2';

  @override
  String get platformPs3 => 'PlayStation 3';

  @override
  String get statusReady => '準備完了';

  @override
  String get statusRunning => '実行中';

  @override
  String get statusPaused => '一時停止';

  @override
  String get statusStopped => '停止';

  @override
  String get statusCompilingShaders => 'シェーダーをコンパイル中...';

  @override
  String get statusBootingKernel => 'カーネルを起動中...';

  @override
  String get statusLoadingDisc => 'ディスクを読み込み中...';

  @override
  String get telemetryFps => 'FPS';

  @override
  String get telemetryFrameTime => 'フレーム時間';

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
  String get actionPlay => 'プレイ';

  @override
  String get actionPause => '一時停止';

  @override
  String get actionResume => '再開';

  @override
  String get actionStop => '停止';

  @override
  String get actionRestart => 'リスタート';

  @override
  String get actionLoadState => 'ステートロード';

  @override
  String get actionSaveState => 'ステートセーブ';

  @override
  String get actionQuickMenu => 'クイックメニュー';

  @override
  String get actionInstallPkg => 'PKG/PUPをインストール';

  @override
  String get actionInsertDisc => 'ディスクを挿入';

  @override
  String get actionEjectDisc => 'ディスクを取り出す';

  @override
  String get storageMemoryCard => 'メモリーカード';

  @override
  String get storageMemoryCardSlot1 => 'メモリーカード スロット1';

  @override
  String get storageMemoryCardSlot2 => 'メモリーカード スロット2';

  @override
  String get storagePs3Hdd => 'PS3仮想HDD';

  @override
  String storageBlocksFree(int count) {
    return '空き $count ブロック';
  }

  @override
  String get storageFormat => 'メモリーカードを初期化';

  @override
  String get storageFormatConfirm =>
      'このメモリーカードを初期化しますか？保存されているすべてのセーブデータが完全に消去されます。';

  @override
  String get storageFormatSuccess => 'メモリーカードの初期化が完了しました。';

  @override
  String get trophyUnlocked => 'トロフィーを獲得しました！';

  @override
  String get trophyBronze => 'ブロンズ';

  @override
  String get trophySilver => 'シルバー';

  @override
  String get trophyGold => 'ゴールド';

  @override
  String get trophyPlatinum => 'プラチナ';

  @override
  String get settingsGeneral => '全般';

  @override
  String get settingsGraphics => 'グラフィックス';

  @override
  String get settingsAudio => 'オーディオ';

  @override
  String get settingsInput => '入力とコントローラー';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get settingsThemeLight => 'ライトモード';

  @override
  String get settingsThemeDark => 'ダークモード';

  @override
  String get settingsThemeSystem => 'システム標準';

  @override
  String get settingsInternalResolution => '内部解像度スケーリング';

  @override
  String get settingsShaderPreset => 'ポストプロセスフィルター';

  @override
  String get settingsShaderNone => 'バイリニア';

  @override
  String get settingsShaderCrt => 'CRT Royale ブラウン管';

  @override
  String get settingsShaderScanlines => 'スキャンライン';

  @override
  String get errorTitle => 'エミュレーションエラー';

  @override
  String get errorUnknown => 'エミュレーション中に予期しないエラーが発生しました。';

  @override
  String get errorDiscRead => 'ディスクイメージの読み込みに失敗しました。ファイルが破損している可能性があります。';

  @override
  String get errorUdfFs => 'Blu-ray UDF 2.50 ファイルシステムの解析に失敗しました。';

  @override
  String get errorIsoDecryption =>
      '暗号化されたPS3ディスクを検出しました。復号キー (.ird / .dkey) が見つかりません。';

  @override
  String get errorParamSfo => 'PARAM.SFO メタデータの解析に失敗しました。';

  @override
  String get errorSelfDecryption =>
      'SELF/SPRXバイナリの復号に失敗しました。SCE/NPDRM署名の検証に失敗しました。';

  @override
  String get errorPkgRapMissing => 'インストールされたPKGパッケージの .rap ライセンスファイルがありません。';

  @override
  String get errorFirmwareMissing =>
      '必要なファームウェアまたはBIOSファイルが見つかりません。システムソフトウェアをインストールしてください。';

  @override
  String get errorMemoryCardCorrupt => 'メモリーカードイメージが破損しているか、チェックサム検証に失敗しました。';

  @override
  String get errorPs3SaveDataSignature => 'PS3セーブデータの検証に失敗しました（PARAM.PFD署名破損）。';

  @override
  String get errorSaveStateVersion => 'セーブステートのバージョンがこのコアと互換性がありません。';

  @override
  String get errorAudioInit => '低遅延オーディオ出力の初期化に失敗しました。';

  @override
  String get errorGpuInit => 'GPUレンダラーの初期化に失敗しました。Vulkan/Metalの互換性を確認してください。';

  @override
  String get errorJitAllocation => 'JIT実行可能コードキャッシュメモリの割り当てに失敗しました。';

  @override
  String get actionOk => 'OK';

  @override
  String get actionCancel => 'キャンセル';

  @override
  String get filterAll => 'すべての機種';

  @override
  String get actionHideHud => 'HUDを非表示';

  @override
  String get actionShowHud => 'HUDを表示';

  @override
  String get actionSimulateTrophy => 'トロフィー解除のシミュレーション';

  @override
  String saveStateSuccess(int slot) {
    return 'ステートセーブが正常に完了しました (スロット $slot)。';
  }

  @override
  String loadStateSuccess(int slot) {
    return 'ステートロードが正常に完了しました (スロット $slot)。';
  }

  @override
  String get trophyGrandMaster => 'OmniStation グランドマスター';

  @override
  String unitMilliseconds(String value) {
    return '$value ミリ秒';
  }

  @override
  String percentFormat(int value) {
    return '$value%';
  }

  @override
  String get statusRtlActive => 'RTL有効';

  @override
  String get tagRtl => '(RTL)';

  @override
  String get settingsGraphicsScaleDesc => 'Vulkan 1.3 / Metal 3 ハードウェアスケーラー';

  @override
  String get settingsResNative => '1x ネイティブ';

  @override
  String get settingsRes1440p => '2x (1440p Quad HD)';

  @override
  String get settingsRes4k => '4x (4K Ultra HD)';

  @override
  String get settingsRes8k => '8x (8K エクストリーム)';

  @override
  String get settingsShaderDesc => 'Impeller リアルタイムシェーダーパイプライン';

  @override
  String get storagePs1Capacity => 'PlayStation 1 (128 KB)';

  @override
  String get storagePs2Capacity => 'PlayStation 2 (8 MB)';

  @override
  String get storagePfdValid => 'PARAM.PFD署名有効';

  @override
  String get storagePs3HddPath => 'dev_hdd0/home/00000001/savedata';

  @override
  String storagePs3HddUsage(String used, String total) {
    return '$used GB / $total GB';
  }

  @override
  String get trophyPioneerTitle => 'OmniStation パイオニア';

  @override
  String get trophyPioneerDesc => 'OmniStation マルチシステムエミュレーターを初めて起動しました。';

  @override
  String get trophyVeteranTitle => 'ハードウェアベテラン';

  @override
  String get trophyVeteranDesc =>
      'Metal 3 および Vulkan 1.3 ゼロコピーテクスチャパイプラインを設定しました。';

  @override
  String get trophyCellMasterTitle => 'Cell Broadband Engine マスター';

  @override
  String get trophyCellMasterDesc =>
      'PowerPC PPE と 6 つの SPU スレッドをジッターなしで並行実行しました。';

  @override
  String get trophyArchitectTitle => 'プラチナアーキテクト';

  @override
  String get trophyArchitectDesc =>
      'C++23、Rust、Flutter 3.x でテストカバレッジ 100% を達成しました。';

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
      'exdata に EP0001-BLES00001_00.rap が見つかりません';

  @override
  String get defaultGameTitle => 'OmniStation ゲーム';

  @override
  String get actionImportGame => 'ゲームをインポート';

  @override
  String get actionDeleteGame => 'ゲームを削除';

  @override
  String get dialogDeleteGameConfirm => 'このゲームをライブラリから削除してもよろしいですか？';

  @override
  String msgGameImportSuccess(String title) {
    return 'ゲームが正常にインポートされました: $title';
  }

  @override
  String msgGameImportFailed(String error) {
    return 'ゲームのインポートに失敗しました: $error';
  }

  @override
  String get emptyLibraryTitle => 'ゲームがインストールされていません';

  @override
  String get emptyLibraryDesc =>
      'ROM またはディスクイメージ（.smc、.sfc、.msc、.iso、.zip、.pkg、.bin）をインポートしてプレイを開始してください。';

  @override
  String get storageTotalAppSpace => '使用中の総ストレージ容量';

  @override
  String get storageGamesSpace => 'インストール済みゲーム';

  @override
  String get storageSavesSpace => 'セーブステート & SRAM';

  @override
  String get storageCardsSpace => '仮想メモリーカード';

  @override
  String get storageFreeSpace => '端末の空き容量';

  @override
  String get storageClearCache => 'キャッシュを消去';

  @override
  String get storageClearCacheSuccess => 'キャッシュが正常に消去されました。';

  @override
  String get emptyTrophiesTitle => '獲得したトロフィーはありません';

  @override
  String get emptyTrophiesDesc => 'ゲームをプレイしてマイルストーンを達成し、トロフィーを獲得しましょう。';

  @override
  String get actionScanDirectory => 'フォルダをスキャン';

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
