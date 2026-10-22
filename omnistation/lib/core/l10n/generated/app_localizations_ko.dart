// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'OmniStation';

  @override
  String get tagline => '초고성능 멀티 시스템 에뮬레이터';

  @override
  String get navLibrary => '라이브러리';

  @override
  String get navStorage => '저장소 관리';

  @override
  String get navTrophies => '트로피';

  @override
  String get navSettings => '설정';

  @override
  String get platformSnes => '슈퍼 패미컴 (SNES)';

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
  String get platformWii => '닌텐도 Wii';

  @override
  String get platformWiiU => '닌텐도 Wii U';

  @override
  String get statusReady => '준비 완료';

  @override
  String get statusRunning => '실행 중';

  @override
  String get statusPaused => '일시 중지됨';

  @override
  String get statusStopped => '중지됨';

  @override
  String get statusCompilingShaders => '셰이더 컴파일 중...';

  @override
  String get statusBootingKernel => '커널 부팅 중...';

  @override
  String get statusLoadingDisc => '디스크 로딩 중...';

  @override
  String get telemetryFps => 'FPS';

  @override
  String get telemetryFrameTime => '프레임 타임';

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
  String get actionPlay => '플레이';

  @override
  String get actionPause => '일시 중지';

  @override
  String get actionResume => '다시 시작';

  @override
  String get actionStop => '정지';

  @override
  String get actionRestart => '재부팅';

  @override
  String get actionLoadState => '상태 불러오기';

  @override
  String get actionSaveState => '상태 저장';

  @override
  String get actionQuickMenu => '빠른 메뉴';

  @override
  String get actionInstallPkg => 'PKG/PUP 설치';

  @override
  String get actionInsertDisc => '디스크 삽입';

  @override
  String get actionEjectDisc => '디스크 꺼내기';

  @override
  String get storageMemoryCard => '메모리 카드';

  @override
  String get storageMemoryCardSlot1 => '메모리 카드 슬롯 1';

  @override
  String get storageMemoryCardSlot2 => '메모리 카드 슬롯 2';

  @override
  String get storagePs3Hdd => 'PS3 가상 하드디스크';

  @override
  String storageBlocksFree(int count) {
    return '$count개 블록 남음';
  }

  @override
  String get storageFormat => '메모리 카드 포맷';

  @override
  String get storageFormatConfirm =>
      '이 메모리 카드를 포맷하시겠습니까? 저장된 모든 데이터가 영구적으로 삭제됩니다.';

  @override
  String get storageFormatSuccess => '메모리 카드가 성공적으로 포맷되었습니다.';

  @override
  String get trophyUnlocked => '트로피 획득!';

  @override
  String get trophyBronze => '브론즈';

  @override
  String get trophySilver => '실버';

  @override
  String get trophyGold => '골드';

  @override
  String get trophyPlatinum => '플래티넘';

  @override
  String get settingsGeneral => '일반';

  @override
  String get settingsGraphics => '그래픽';

  @override
  String get settingsAudio => '오디오';

  @override
  String get settingsInput => '입력 및 컨트롤러';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsTheme => '테마';

  @override
  String get settingsThemeLight => '라이트 모드';

  @override
  String get settingsThemeDark => '다크 모드';

  @override
  String get settingsThemeSystem => '시스템 기본값';

  @override
  String get settingsInternalResolution => '내부 렌더링 해상도 스케일링';

  @override
  String get settingsShaderPreset => '후처리 필터';

  @override
  String get settingsShaderNone => '바이리니어';

  @override
  String get settingsShaderCrt => 'CRT Royale 브라운관';

  @override
  String get settingsShaderScanlines => '스캔라인';

  @override
  String get errorTitle => '에뮬레이션 오류';

  @override
  String get errorUnknown => '에뮬레이션 중 예기치 않은 오류가 발생했습니다.';

  @override
  String get errorDiscRead => '디스크 이미지를 읽지 못했습니다. 파일이 손상되었거나 접근할 수 없습니다.';

  @override
  String get errorUdfFs => 'Blu-ray UDF 2.50 파일 시스템 분석에 실패했습니다.';

  @override
  String get errorIsoDecryption =>
      '암호화된 PS3 디스크가 감지되었습니다. 복호화 키(.ird / .dkey)가 누락되었거나 유효하지 않습니다.';

  @override
  String get errorParamSfo => 'PARAM.SFO 메타데이터 분석에 실패했습니다.';

  @override
  String get errorSelfDecryption =>
      'SELF/SPRX 바이너리 복호화에 실패했습니다. SCE/NPDRM 서명 검증 실패.';

  @override
  String get errorPkgRapMissing => '설치된 PKG 패키지의 .rap 라이선스 파일이 누락되었습니다.';

  @override
  String get errorFirmwareMissing =>
      '필수 펌웨어 또는 BIOS 파일을 찾을 수 없습니다. 시스템 소프트웨어를 설치하십시오.';

  @override
  String get errorMemoryCardCorrupt => '메모리 카드 이미지가 손상되었거나 체크섬 검증에 실패했습니다.';

  @override
  String get errorPs3SaveDataSignature => 'PS3 저장 데이터 검증 실패 (PARAM.PFD 서명 손상).';

  @override
  String get errorSaveStateVersion => '저장 상태 버전이 현재 에뮬레이션 코어와 호환되지 않습니다.';

  @override
  String get errorAudioInit => '저지연 오디오 장치 초기화에 실패했습니다.';

  @override
  String get errorGpuInit => '하드웨어 GPU 렌더러 초기화 실패. Vulkan/Metal 드라이버를 확인하십시오.';

  @override
  String get errorJitAllocation => '실행 가능한 JIT 코드 캐시 메모리 할당에 실패했습니다.';

  @override
  String get actionOk => '확인';

  @override
  String get actionCancel => '취소';

  @override
  String get filterAll => '모든 콘솔';

  @override
  String get actionHideHud => 'HUD 숨기기';

  @override
  String get actionShowHud => 'HUD 표시';

  @override
  String get actionSimulateTrophy => '트로피 잠금 해제 시뮬레이션';

  @override
  String saveStateSuccess(int slot) {
    return '강제 저장이 성공적으로 완료되었습니다 (슬롯 $slot).';
  }

  @override
  String loadStateSuccess(int slot) {
    return '강제 저장이 성공적으로 복원되었습니다 (슬롯 $slot).';
  }

  @override
  String get trophyGrandMaster => 'OmniStation 그랜드 마스터';

  @override
  String unitMilliseconds(String value) {
    return '$value ms';
  }

  @override
  String percentFormat(int value) {
    return '$value%';
  }

  @override
  String get statusRtlActive => 'RTL 활성화됨';

  @override
  String get tagRtl => '(RTL)';

  @override
  String get settingsGraphicsScaleDesc => 'Vulkan 1.3 / Metal 3 하드웨어 업스케일러';

  @override
  String get settingsResNative => '1x 네이티브';

  @override
  String get settingsRes1440p => '2x (1440p Quad HD)';

  @override
  String get settingsRes4k => '4x (4K Ultra HD)';

  @override
  String get settingsRes8k => '8x (8K 익스트림)';

  @override
  String get settingsShaderDesc => 'Impeller 실시간 셰이더 파이프라인';

  @override
  String get storagePs1Capacity => 'PlayStation 1 (128 KB)';

  @override
  String get storagePs2Capacity => 'PlayStation 2 (8 MB)';

  @override
  String get storagePfdValid => 'PARAM.PFD 유효함';

  @override
  String get storagePs3HddPath => 'dev_hdd0/home/00000001/savedata';

  @override
  String storagePs3HddUsage(String used, String total) {
    return '$used GB / $total GB';
  }

  @override
  String get trophyPioneerTitle => 'OmniStation 개척자';

  @override
  String get trophyPioneerDesc => 'OmniStation 멀티 시스템 에뮬레이터를 처음으로 실행했습니다.';

  @override
  String get trophyVeteranTitle => '하드웨어 베테랑';

  @override
  String get trophyVeteranDesc =>
      'Metal 3 및 Vulkan 1.3 제로 카피 텍스처 파이프라인을 구성했습니다.';

  @override
  String get trophyCellMasterTitle => 'Cell Broadband Engine 마스터';

  @override
  String get trophyCellMasterDesc =>
      'PowerPC PPE와 6개 SPU 스레드를 지터 없이 동시에 실행했습니다.';

  @override
  String get trophyArchitectTitle => '플래티넘 아키텍트';

  @override
  String get trophyArchitectDesc =>
      'C++23, Rust 및 Flutter 3.x에서 100% 테스트 커버리지를 달성했습니다.';

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
      'exdata에서 EP0001-BLES00001_00.rap을 찾을 수 없습니다';

  @override
  String get defaultGameTitle => 'OmniStation 게임';

  @override
  String get actionImportGame => '게임 가져오기';

  @override
  String get actionDeleteGame => '게임 삭제';

  @override
  String get dialogDeleteGameConfirm => '라이브러리에서 이 게임을 삭제하시겠습니까?';

  @override
  String msgGameImportSuccess(String title) {
    return '게임을 성공적으로 가져왔습니다: $title';
  }

  @override
  String msgGameImportFailed(String error) {
    return '게임 가져오기 실패: $error';
  }

  @override
  String get emptyLibraryTitle => '설치된 게임 없음';

  @override
  String get emptyLibraryDesc =>
      'ROM 또는 디스크 이미지(.smc, .sfc, .msc, .iso, .zip, .pkg, .bin)를 가져와 플레이를 시작하세요.';

  @override
  String get storageTotalAppSpace => '총 사용 저장 공간';

  @override
  String get storageGamesSpace => '설치된 게임';

  @override
  String get storageSavesSpace => '저장 상태 및 SRAM';

  @override
  String get storageCardsSpace => '가상 메모리 카드';

  @override
  String get storageFreeSpace => '기기 여유 공간';

  @override
  String get storageClearCache => '캐시 지우기';

  @override
  String get storageClearCacheSuccess => '캐시를 성공적으로 지웠습니다.';

  @override
  String get emptyTrophiesTitle => '획득한 트로피 없음';

  @override
  String get emptyTrophiesDesc => '게임을 플레이하고 목표를 달성하여 트로피를 획득하세요.';

  @override
  String get actionScanDirectory => '폴더 검색';

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
