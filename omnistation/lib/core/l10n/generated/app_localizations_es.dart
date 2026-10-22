// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'OmniStation';

  @override
  String get tagline => 'Emulador Multi-Sistema de Alto Rendimiento';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navStorage => 'Almacenamiento';

  @override
  String get navTrophies => 'Trofeos';

  @override
  String get navSettings => 'Ajustes';

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
  String get statusReady => 'Listo';

  @override
  String get statusRunning => 'En ejecución';

  @override
  String get statusPaused => 'Pausado';

  @override
  String get statusStopped => 'Detenido';

  @override
  String get statusCompilingShaders => 'Compilando Shaders...';

  @override
  String get statusBootingKernel => 'Iniciando Kernel...';

  @override
  String get statusLoadingDisc => 'Cargando Disco Óptico...';

  @override
  String get telemetryFps => 'FPS';

  @override
  String get telemetryFrameTime => 'Tiempo de Frame';

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
  String get actionPlay => 'Jugar';

  @override
  String get actionPause => 'Pausar';

  @override
  String get actionResume => 'Reanudar';

  @override
  String get actionStop => 'Detener';

  @override
  String get actionRestart => 'Reiniciar';

  @override
  String get actionLoadState => 'Cargar Estado';

  @override
  String get actionSaveState => 'Guardar Estado';

  @override
  String get actionQuickMenu => 'Menú Rápido';

  @override
  String get actionInstallPkg => 'Instalar PKG/PUP';

  @override
  String get actionInsertDisc => 'Insertar Disco';

  @override
  String get actionEjectDisc => 'Expulsar Disco';

  @override
  String get storageMemoryCard => 'Memory Card';

  @override
  String get storageMemoryCardSlot1 => 'Memory Card Ranura 1';

  @override
  String get storageMemoryCardSlot2 => 'Memory Card Ranura 2';

  @override
  String get storagePs3Hdd => 'HDD Virtual PS3';

  @override
  String storageBlocksFree(int count) {
    return '$count bloques libres';
  }

  @override
  String get storageFormat => 'Formatear Tarjeta';

  @override
  String get storageFormatConfirm =>
      '¿Estás seguro de que deseas formatear esta Memory Card? Todos los datos guardados se borrarán permanentemente.';

  @override
  String get storageFormatSuccess => 'Memory Card formateada exitosamente.';

  @override
  String get trophyUnlocked => '¡Trofeo Desbloqueado!';

  @override
  String get trophyBronze => 'Bronce';

  @override
  String get trophySilver => 'Plata';

  @override
  String get trophyGold => 'Oro';

  @override
  String get trophyPlatinum => 'Platino';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsGraphics => 'Gráficos';

  @override
  String get settingsAudio => 'Audio';

  @override
  String get settingsInput => 'Entrada y Mandos';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeLight => 'Modo Claro';

  @override
  String get settingsThemeDark => 'Modo Oscuro';

  @override
  String get settingsThemeSystem => 'Predeterminado del Sistema';

  @override
  String get settingsInternalResolution => 'Escalado de Resolución Interna';

  @override
  String get settingsShaderPreset => 'Filtro de Post-Procesamiento';

  @override
  String get settingsShaderNone => 'Bilineal';

  @override
  String get settingsShaderCrt => 'CRT Royale';

  @override
  String get settingsShaderScanlines => 'Scanlines';

  @override
  String get errorTitle => 'Error de Emulación';

  @override
  String get errorUnknown =>
      'Ocurrió un error inesperado durante la emulación.';

  @override
  String get errorDiscRead =>
      'Fallo al leer la imagen de disco óptico. El archivo puede estar dañado o inaccesible.';

  @override
  String get errorUdfFs =>
      'Fallo al analizar el sistema de archivos Blu-ray UDF 2.50.';

  @override
  String get errorIsoDecryption =>
      'Disco de PS3 encriptado detectado. Clave de desencriptado ausente o inválida (.ird / .dkey).';

  @override
  String get errorParamSfo =>
      'Fallo al leer o analizar los metadatos de PARAM.SFO.';

  @override
  String get errorSelfDecryption =>
      'Fallo al desencriptar el binario SELF/SPRX. Verificación de firma SCE/NPDRM fallida.';

  @override
  String get errorPkgRapMissing =>
      'Archivo de licencia .rap ausente para el paquete PKG instalado.';

  @override
  String get errorFirmwareMissing =>
      'No se encontró el firmware requerido o la BIOS. Por favor, instala el software del sistema.';

  @override
  String get errorMemoryCardCorrupt =>
      'La imagen de la Memory Card está dañada o falló la verificación de checksum.';

  @override
  String get errorPs3SaveDataSignature =>
      'Verificación de guardado de PS3 fallida (firma criptográfica PARAM.PFD dañada).';

  @override
  String get errorSaveStateVersion =>
      'La versión del estado de guardado es incompatible con esta versión del núcleo.';

  @override
  String get errorAudioInit =>
      'Fallo al inicializar el receptor de audio de baja latencia.';

  @override
  String get errorGpuInit =>
      'El renderizador de GPU por hardware falló al inicializar. Verifica la compatibilidad con Vulkan/Metal.';

  @override
  String get errorJitAllocation =>
      'Fallo al asignar memoria ejecutable para el caché de código JIT.';

  @override
  String get actionOk => 'Aceptar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get filterAll => 'Todas las Consolas';

  @override
  String get actionHideHud => 'Ocultar HUD';

  @override
  String get actionShowHud => 'Mostrar HUD';

  @override
  String get actionSimulateTrophy => 'Simular Desbloqueo de Trofeo';

  @override
  String saveStateSuccess(int slot) {
    return 'Estado guardado con éxito (Ranura $slot).';
  }

  @override
  String loadStateSuccess(int slot) {
    return 'Estado cargado con éxito (Ranura $slot).';
  }

  @override
  String get trophyGrandMaster => 'Gran Maestro de OmniStation';

  @override
  String unitMilliseconds(String value) {
    return '$value ms';
  }

  @override
  String percentFormat(int value) {
    return '$value%';
  }

  @override
  String get statusRtlActive => 'RTL Activo';

  @override
  String get tagRtl => '(RTL)';

  @override
  String get settingsGraphicsScaleDesc =>
      'Escalador por Hardware Vulkan 1.3 / Metal 3';

  @override
  String get settingsResNative => '1x Nativo';

  @override
  String get settingsRes1440p => '2x (1440p Quad HD)';

  @override
  String get settingsRes4k => '4x (4K Ultra HD)';

  @override
  String get settingsRes8k => '8x (8K Extremo)';

  @override
  String get settingsShaderDesc => 'Tubería de Shaders en Tiempo Real Impeller';

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
  String get trophyPioneerTitle => 'Pionero de OmniStation';

  @override
  String get trophyPioneerDesc =>
      'Inició el emulador multi-sistema OmniStation por primera vez.';

  @override
  String get trophyVeteranTitle => 'Veterano del Hardware';

  @override
  String get trophyVeteranDesc =>
      'Configuró la tubería de texturas de copia cero Metal 3 y Vulkan 1.3.';

  @override
  String get trophyCellMasterTitle => 'Maestro de Cell Broadband Engine';

  @override
  String get trophyCellMasterDesc =>
      'Ejecutó PPE PowerPC y 6 hilos SPU concurrentemente con 0 jitter.';

  @override
  String get trophyArchitectTitle => 'Arquitecto Platino';

  @override
  String get trophyArchitectDesc =>
      'Alcanzó el 100% de cobertura de pruebas en C++23, Rust y Flutter 3.x.';

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
      'EP0001-BLES00001_00.rap no encontrado en exdata';

  @override
  String get defaultGameTitle => 'Juego de OmniStation';

  @override
  String get actionImportGame => 'Importar Juego';

  @override
  String get actionDeleteGame => 'Eliminar Juego';

  @override
  String get dialogDeleteGameConfirm =>
      '¿Estás seguro de que deseas eliminar este juego de tu biblioteca?';

  @override
  String msgGameImportSuccess(String title) {
    return 'Juego importado con éxito: $title';
  }

  @override
  String msgGameImportFailed(String error) {
    return 'Error al importar el juego: $error';
  }

  @override
  String get emptyLibraryTitle => 'No Hay Juegos Instalados';

  @override
  String get emptyLibraryDesc =>
      'Importa ROMs o imágenes de disco (.smc, .sfc, .msc, .iso, .zip, .pkg, .bin, .pbp, .cso, .vpk, .wbfs, .rvz, .wud, .rpx) para comenzar a jugar.';

  @override
  String get storageTotalAppSpace => 'Almacenamiento Total Usado';

  @override
  String get storageGamesSpace => 'Juegos Instalados';

  @override
  String get storageSavesSpace => 'Estados Guardados y SRAM';

  @override
  String get storageCardsSpace => 'Tarjetas de Memoria Virtuales';

  @override
  String get storageFreeSpace => 'Espacio Libre en Dispositivo';

  @override
  String get storageClearCache => 'Limpiar Caché';

  @override
  String get storageClearCacheSuccess => 'Caché limpiada con éxito.';

  @override
  String get emptyTrophiesTitle => 'Sin Trofeos Obtenidos';

  @override
  String get emptyTrophiesDesc =>
      'Juega y completa logros en los juegos para ganar trofeos.';

  @override
  String get actionScanDirectory => 'Escanear Carpeta';

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
