// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'OmniStation';

  @override
  String get tagline => 'Emulador Multi-Sistema de Alto Desempenho';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navStorage => 'Armazenamento';

  @override
  String get navTrophies => 'Troféus';

  @override
  String get navSettings => 'Configurações';

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
  String get statusRunning => 'Em Execução';

  @override
  String get statusPaused => 'Pausado';

  @override
  String get statusStopped => 'Parado';

  @override
  String get statusCompilingShaders => 'Compilando Shaders...';

  @override
  String get statusBootingKernel => 'Iniciando Kernel...';

  @override
  String get statusLoadingDisc => 'Carregando Disco Óptico...';

  @override
  String get telemetryFps => 'FPS';

  @override
  String get telemetryFrameTime => 'Tempo de Quadro';

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
  String get actionPlay => 'Jogar';

  @override
  String get actionPause => 'Pausar';

  @override
  String get actionResume => 'Retomar';

  @override
  String get actionStop => 'Parar';

  @override
  String get actionRestart => 'Reiniciar';

  @override
  String get actionLoadState => 'Carregar Estado';

  @override
  String get actionSaveState => 'Salvar Estado';

  @override
  String get actionQuickMenu => 'Menu Rápido';

  @override
  String get actionInstallPkg => 'Instalar PKG/PUP';

  @override
  String get actionInsertDisc => 'Inserir Disco';

  @override
  String get actionEjectDisc => 'Ejetar Disco';

  @override
  String get storageMemoryCard => 'Memory Card';

  @override
  String get storageMemoryCardSlot1 => 'Memory Card Slot 1';

  @override
  String get storageMemoryCardSlot2 => 'Memory Card Slot 2';

  @override
  String get storagePs3Hdd => 'HDD Virtual PS3';

  @override
  String storageBlocksFree(int count) {
    return '$count blocos livres';
  }

  @override
  String get storageFormat => 'Formatar Cartão';

  @override
  String get storageFormatConfirm =>
      'Tem certeza de que deseja formatar este Memory Card? Todos os dados salvos serão permanentemente apagados.';

  @override
  String get storageFormatSuccess => 'Memory Card formatado com sucesso.';

  @override
  String get trophyUnlocked => 'Troféu Desbloqueado!';

  @override
  String get trophyBronze => 'Bronze';

  @override
  String get trophySilver => 'Prata';

  @override
  String get trophyGold => 'Ouro';

  @override
  String get trophyPlatinum => 'Platina';

  @override
  String get settingsGeneral => 'Geral';

  @override
  String get settingsGraphics => 'Gráficos';

  @override
  String get settingsAudio => 'Áudio';

  @override
  String get settingsInput => 'Controles e Entrada';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeLight => 'Modo Claro';

  @override
  String get settingsThemeDark => 'Modo Escuro';

  @override
  String get settingsThemeSystem => 'Padrão do Sistema';

  @override
  String get settingsInternalResolution => 'Escala de Resolução Interna';

  @override
  String get settingsShaderPreset => 'Filtro de Pós-Processamento';

  @override
  String get settingsShaderNone => 'Bilinear';

  @override
  String get settingsShaderCrt => 'CRT Royale';

  @override
  String get settingsShaderScanlines => 'Scanlines';

  @override
  String get errorTitle => 'Erro de Emulação';

  @override
  String get errorUnknown => 'Ocorreu um erro inesperado durante a emulação.';

  @override
  String get errorDiscRead =>
      'Falha ao ler a imagem do disco óptico. O arquivo pode estar corrompido ou inacessível.';

  @override
  String get errorUdfFs =>
      'Falha ao analisar o sistema de arquivos Blu-ray UDF 2.50.';

  @override
  String get errorIsoDecryption =>
      'Disco PS3 criptografado detectado. Chave de descriptografia ausente ou inválida (.ird / .dkey).';

  @override
  String get errorParamSfo => 'Falha ao ler ou analisar metadados PARAM.SFO.';

  @override
  String get errorSelfDecryption =>
      'Falha ao descriptografar binário SELF/SPRX. Verificação de assinatura SCE/NPDRM falhou.';

  @override
  String get errorPkgRapMissing =>
      'Arquivo de licença .rap ausente para o pacote PKG instalado.';

  @override
  String get errorFirmwareMissing =>
      'Firmware ou arquivo de BIOS obrigatório não foi encontrado. Instale o software do sistema.';

  @override
  String get errorMemoryCardCorrupt =>
      'A imagem do Memory Card está corrompida ou falhou na verificação de checksum.';

  @override
  String get errorPs3SaveDataSignature =>
      'Verificação de salvamento do PS3 falhou (assinatura PARAM.PFD corrompida).';

  @override
  String get errorSaveStateVersion =>
      'A versão do estado de salvamento é incompatível com esta versão do núcleo.';

  @override
  String get errorAudioInit =>
      'Falha ao inicializar a saída de áudio de baixa latência.';

  @override
  String get errorGpuInit =>
      'O renderizador de GPU falhou ao inicializar. Verifique a compatibilidade com Vulkan/Metal.';

  @override
  String get errorJitAllocation =>
      'Falha ao alocar memória executável para o cache de código JIT.';

  @override
  String get actionOk => 'OK';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get filterAll => 'Todos os Consoles';

  @override
  String get actionHideHud => 'Ocultar HUD';

  @override
  String get actionShowHud => 'Mostrar HUD';

  @override
  String get actionSimulateTrophy => 'Simular Desbloqueio de Troféu';

  @override
  String saveStateSuccess(int slot) {
    return 'Save state concluído com sucesso (Slot $slot).';
  }

  @override
  String loadStateSuccess(int slot) {
    return 'Save state restaurado com sucesso (Slot $slot).';
  }

  @override
  String get trophyGrandMaster => 'Grão-Mestre OmniStation';

  @override
  String unitMilliseconds(String value) {
    return '$value ms';
  }

  @override
  String percentFormat(int value) {
    return '$value%';
  }

  @override
  String get statusRtlActive => 'RTL Ativo';

  @override
  String get tagRtl => '(RTL)';

  @override
  String get settingsGraphicsScaleDesc =>
      'Escalador de Hardware Vulkan 1.3 / Metal 3';

  @override
  String get settingsResNative => '1x Nativo';

  @override
  String get settingsRes1440p => '2x (1440p Quad HD)';

  @override
  String get settingsRes4k => '4x (4K Ultra HD)';

  @override
  String get settingsRes8k => '8x (8K Extremo)';

  @override
  String get settingsShaderDesc => 'Pipeline de Shaders em Tempo Real Impeller';

  @override
  String get storagePs1Capacity => 'PlayStation 1 (128 KB)';

  @override
  String get storagePs2Capacity => 'PlayStation 2 (8 MB)';

  @override
  String get storagePfdValid => 'PARAM.PFD Válido';

  @override
  String get storagePs3HddPath => 'dev_hdd0/home/00000001/savedata';

  @override
  String storagePs3HddUsage(String used, String total) {
    return '$used GB / $total GB';
  }

  @override
  String get trophyPioneerTitle => 'Pioneiro OmniStation';

  @override
  String get trophyPioneerDesc =>
      'Iniciou o emulador multi-sistema OmniStation pela primeira vez.';

  @override
  String get trophyVeteranTitle => 'Veterano de Hardware';

  @override
  String get trophyVeteranDesc =>
      'Configurou pipeline de texturas zero-copy Metal 3 e Vulkan 1.3.';

  @override
  String get trophyCellMasterTitle => 'Mestre do Cell Broadband Engine';

  @override
  String get trophyCellMasterDesc =>
      'Executou PPE PowerPC e 6 threads SPU simultaneamente sem instabilidade.';

  @override
  String get trophyArchitectTitle => 'Arquiteto Platina';

  @override
  String get trophyArchitectDesc =>
      'Alcançou 100% de cobertura de testes em C++23, Rust e Flutter 3.x.';

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
      'EP0001-BLES00001_00.rap não encontrado em exdata';

  @override
  String get defaultGameTitle => 'Jogo OmniStation';

  @override
  String get actionImportGame => 'Importar Jogo';

  @override
  String get actionDeleteGame => 'Excluir Jogo';

  @override
  String get dialogDeleteGameConfirm =>
      'Tem certeza de que deseja remover este jogo da sua biblioteca?';

  @override
  String msgGameImportSuccess(String title) {
    return 'Jogo importado com sucesso: $title';
  }

  @override
  String msgGameImportFailed(String error) {
    return 'Falha ao importar o jogo: $error';
  }

  @override
  String get emptyLibraryTitle => 'Nenhum Jogo Instalado';

  @override
  String get emptyLibraryDesc =>
      'Importe ROMs ou imagens de disco (.smc, .sfc, .msc, .iso, .zip, .pkg, .bin) para começar a jogar.';

  @override
  String get storageTotalAppSpace => 'Armazenamento Total Usado';

  @override
  String get storageGamesSpace => 'Jogos Instalados';

  @override
  String get storageSavesSpace => 'Estados Salvos e SRAM';

  @override
  String get storageCardsSpace => 'Cartões de Memória Virtuais';

  @override
  String get storageFreeSpace => 'Espaço Livre no Dispositivo';

  @override
  String get storageClearCache => 'Limpar Cache';

  @override
  String get storageClearCacheSuccess => 'Cache limpo com sucesso.';

  @override
  String get emptyTrophiesTitle => 'Nenhum Troféu Conquistado';

  @override
  String get emptyTrophiesDesc =>
      'Jogue e complete metas nos jogos para ganhar troféus.';

  @override
  String get actionScanDirectory => 'Escanear Pasta';

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
