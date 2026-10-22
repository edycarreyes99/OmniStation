import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import '../../core/error/failures.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/game_title.dart';
import '../../domain/entities/emulation_session_state.dart';

final class NativeGameInfoStruct extends Struct {
  @Uint32()
  external int platformId;

  @Array(16)
  external Array<Uint8> titleId;

  @Array(128)
  external Array<Uint8> titleName;

  @Int32()
  external int isValid;
}

final class NativeTelemetryStruct extends Struct {
  @Float()
  external double fps;

  @Float()
  external double frametimeMs;

  @Float()
  external double ppuUsage;

  @Float()
  external double spuUsage;

  @Float()
  external double eeUsage;

  @Float()
  external double gsUsage;

  @Float()
  external double rsxUsage;

  @Uint32()
  external int vramMb;
}

typedef OmnistationInitNative = Int32 Function(Pointer<Utf8> storageRoot);
typedef OmnistationInitDart = int Function(Pointer<Utf8> storageRoot);

typedef OmnistationLoadMediaNative = Int32 Function(
    Pointer<Utf8> mediaPath, Pointer<NativeGameInfoStruct> outInfo);
typedef OmnistationLoadMediaDart = int Function(
    Pointer<Utf8> mediaPath, Pointer<NativeGameInfoStruct> outInfo);

typedef OmnistationGetTelemetryNative = Int32 Function(
    Pointer<NativeTelemetryStruct> outTelemetry);
typedef OmnistationGetTelemetryDart = int Function(
    Pointer<NativeTelemetryStruct> outTelemetry);

typedef OmnistationGetLastErrorCodeNative = Int32 Function(
    Pointer<Utf8> outBuf, IntPtr maxLen);
typedef OmnistationGetLastErrorCodeDart = int Function(
    Pointer<Utf8> outBuf, int maxLen);

typedef OmnistationSnesBootNative = Int32 Function(Pointer<Utf8> romPath);
typedef OmnistationSnesBootDart = int Function(Pointer<Utf8> romPath);

typedef OmnistationSnesStepFrameNative = Int32 Function();
typedef OmnistationSnesStepFrameDart = int Function();

typedef OmnistationSnesGetFramebufferNative = Int32 Function(
    Pointer<Uint8> outBuf, IntPtr maxLen);
typedef OmnistationSnesGetFramebufferDart = int Function(
    Pointer<Uint8> outBuf, int maxLen);

typedef OmnistationSnesSetButtonNative = Int32 Function(
    Int32 button, Int32 pressed);
typedef OmnistationSnesSetButtonDart = int Function(int button, int pressed);

typedef OmnistationSnesStopNative = Int32 Function();
typedef OmnistationSnesStopDart = int Function();

class NativeBridgeDataSource {
  DynamicLibrary? _dylib;
  OmnistationInitDart? _initFn;
  OmnistationLoadMediaDart? _loadMediaFn;
  OmnistationGetTelemetryDart? _getTelemetryFn;
  OmnistationGetLastErrorCodeDart? _getLastErrorCodeFn;
  OmnistationSnesBootDart? _snesBootFn;
  OmnistationSnesStepFrameDart? _snesStepFrameFn;
  OmnistationSnesGetFramebufferDart? _snesGetFramebufferFn;
  OmnistationSnesSetButtonDart? _snesSetButtonFn;
  OmnistationSnesStopDart? _snesStopFn;
  Pointer<Uint8>? _framebufferPtr;
  bool _isInitialized = false;

  NativeBridgeDataSource() {
    _loadDylib();
    if (_dylib != null) {
      _framebufferPtr = calloc<Uint8>(512 * 480 * 4);
      AppLogger.info('NativeBridge', 'Allocated 512x480x4 RGBA raw frame buffer');
    }
  }

  void _loadDylib() {
    AppLogger.info('NativeBridge', 'Initiating dynamic library resolution for ${Platform.operatingSystem} (${Platform.resolvedExecutable})');
    try {
      if (Platform.isMacOS) {
        final exeFile = File(Platform.resolvedExecutable);
        final bundleFrameworks = '${exeFile.parent.parent.path}/Frameworks/libemu_ffi.dylib';
        final bundleMacOS = '${exeFile.parent.path}/libemu_ffi.dylib';

        final candidates = [
          bundleFrameworks,
          bundleMacOS,
          'libemu_ffi.dylib',
          '@rpath/libemu_ffi.dylib',
          '/Users/edycarreyes99/Projects/Odynnix/OmniStation/target/debug/libemu_ffi.dylib',
          '/Users/edycarreyes99/Projects/Odynnix/OmniStation/target/release/libemu_ffi.dylib',
          '../target/debug/libemu_ffi.dylib',
          '../../target/debug/libemu_ffi.dylib',
          '../../../target/debug/libemu_ffi.dylib',
          'target/debug/libemu_ffi.dylib',
          '../Frameworks/libemu_ffi.dylib',
        ];

        for (final p in candidates) {
          try {
            AppLogger.debug('NativeBridge', 'Testing candidate path: $p');
            if (p.startsWith('/') || p.startsWith('.')) {
              if (!File(p).existsSync()) {
                AppLogger.debug('NativeBridge', 'File does not exist: $p');
                continue;
              }
            }
            _dylib = DynamicLibrary.open(p);
            AppLogger.info('NativeBridge', 'Successfully loaded dynamic library from: $p');
            break;
          } catch (e) {
            AppLogger.debug('NativeBridge', 'Failed to open candidate "$p": $e');
          }
        }

        if (_dylib == null) {
          try {
            AppLogger.debug('NativeBridge', 'Attempting DynamicLibrary.process() as fallback');
            _dylib = DynamicLibrary.process();
            AppLogger.info('NativeBridge', 'Successfully attached to host process via DynamicLibrary.process()');
          } catch (e) {
            AppLogger.warn('NativeBridge', 'DynamicLibrary.process() failed: $e');
          }
        }
      } else if (Platform.isLinux || Platform.isAndroid) {
        try {
          _dylib = DynamicLibrary.open('libemu_ffi.so');
          AppLogger.info('NativeBridge', 'Loaded libemu_ffi.so');
        } catch (e) {
          AppLogger.warn('NativeBridge', 'DynamicLibrary.open(libemu_ffi.so) failed: $e');
          try {
            _dylib = DynamicLibrary.process();
          } catch (_) {}
        }
      } else if (Platform.isWindows) {
        try {
          _dylib = DynamicLibrary.open('emu_ffi.dll');
          AppLogger.info('NativeBridge', 'Loaded emu_ffi.dll');
        } catch (e) {
          AppLogger.warn('NativeBridge', 'DynamicLibrary.open(emu_ffi.dll) failed: $e');
          try {
            _dylib = DynamicLibrary.process();
          } catch (_) {}
        }
      } else {
        _dylib = DynamicLibrary.process();
      }

      if (_dylib != null) {
        try {
          _initFn = _dylib!.lookupFunction<OmnistationInitNative, OmnistationInitDart>(
              'omnistation_init');
          _loadMediaFn = _dylib!.lookupFunction<OmnistationLoadMediaNative,
              OmnistationLoadMediaDart>('omnistation_load_media');
          _getTelemetryFn = _dylib!.lookupFunction<OmnistationGetTelemetryNative,
              OmnistationGetTelemetryDart>('omnistation_get_telemetry');
          _getLastErrorCodeFn = _dylib!.lookupFunction<
              OmnistationGetLastErrorCodeNative,
              OmnistationGetLastErrorCodeDart>('omnistation_get_last_error_code');
          _snesBootFn = _dylib!.lookupFunction<OmnistationSnesBootNative,
              OmnistationSnesBootDart>('omnistation_snes_boot');
          _snesStepFrameFn = _dylib!.lookupFunction<OmnistationSnesStepFrameNative,
              OmnistationSnesStepFrameDart>('omnistation_snes_step_frame');
          _snesGetFramebufferFn = _dylib!.lookupFunction<
              OmnistationSnesGetFramebufferNative,
              OmnistationSnesGetFramebufferDart>('omnistation_snes_get_framebuffer');
          _snesSetButtonFn = _dylib!.lookupFunction<OmnistationSnesSetButtonNative,
              OmnistationSnesSetButtonDart>('omnistation_snes_set_button');
          _snesStopFn = _dylib!.lookupFunction<OmnistationSnesStopNative,
              OmnistationSnesStopDart>('omnistation_snes_stop');
          AppLogger.info('NativeBridge', 'FFI functions registered: init=${_initFn != null}, loadMedia=${_loadMediaFn != null}, snesBoot=${_snesBootFn != null}, snesStep=${_snesStepFrameFn != null}');
        } catch (e, st) {
          AppLogger.error('NativeBridge', 'Symbol lookup failed: $e', e, st);
        }
      } else {
        AppLogger.error('NativeBridge', 'CRITICAL: Failed to load libemu_ffi on any search path! Live core execution will be disabled.');
      }
    } catch (e, st) {
      AppLogger.error('NativeBridge', 'Unexpected error initializing native bridge: $e', e, st);
      _dylib = null;
    }
  }

  bool get isInitialized => _isInitialized;

  String getLastErrorDescription() {
    if (_getLastErrorCodeFn != null) {
      final buf = calloc<Uint8>(256);
      try {
        final res = _getLastErrorCodeFn!(buf.cast<Utf8>(), 256);
        if (res == 0) {
          return buf.cast<Utf8>().toDartString();
        }
      } catch (_) {
        // Fallback
      } finally {
        calloc.free(buf);
      }
    }
    return '';
  }

  AppFailure mapErrorCodeToFailure(int code) {
    switch (code) {
      case 1:
        return const DiscReadFailure();
      case 2:
        return const UdfFsFailure();
      case 3:
        return const IsoDecryptionFailure();
      case 4:
        return const ParamSfoFailure();
      case 5:
        return const SelfDecryptionFailure();
      case 6:
        return const PkgRapMissingFailure();
      case 7:
        return const FirmwareMissingFailure();
      case 8:
        return const MemoryCardCorruptFailure();
      case 9:
        return const Ps3SaveDataSignatureFailure();
      case 10:
        return const SaveStateVersionFailure();
      case 11:
        return const AudioInitFailure();
      case 12:
        return const GpuInitFailure();
      case 13:
        return const JitAllocationFailure();
      default:
        return const UnknownFailure();
    }
  }

  Future<void> initialize(String storageRoot) async {
    AppLogger.info('NativeBridge', 'Initializing OmniStation virtual storage root: $storageRoot');
    if (_initFn != null) {
      final ptr = storageRoot.toNativeUtf8();
      try {
        final res = _initFn!(ptr);
        if (res != 0) {
          final errDesc = getLastErrorDescription();
          AppLogger.error('NativeBridge', 'omnistation_init failed with code $res: $errDesc');
          throw mapErrorCodeToFailure(res);
        }
        _isInitialized = true;
        AppLogger.info('NativeBridge', 'OmniStation virtual storage initialized successfully');
      } catch (e, st) {
        AppLogger.error('NativeBridge', 'Exception during omnistation_init: $e', e, st);
        rethrow;
      } finally {
        calloc.free(ptr);
      }
    } else {
      AppLogger.warn('NativeBridge', 'omnistation_init: Running in fallback mode without native FFI binding');
      _isInitialized = true;
    }
  }

  Future<GameTitle> loadMedia(String path) async {
    AppLogger.info('NativeBridge', 'loadMedia requested for: $path');
    if (_loadMediaFn != null && File(path).existsSync()) {
      final pathPtr = path.toNativeUtf8();
      final infoPtr = calloc<NativeGameInfoStruct>();
      try {
        final res = _loadMediaFn!(pathPtr, infoPtr);
        if (res != 0) {
          final errDesc = getLastErrorDescription();
          AppLogger.error('NativeBridge', 'omnistation_load_media failed with code $res: $errDesc');
          throw mapErrorCodeToFailure(res);
        }

        final platId = infoPtr.ref.platformId;
        final platform = switch (platId) {
          1 => ConsolePlatform.snes,
          2 => ConsolePlatform.ps1,
          3 => ConsolePlatform.ps2,
          _ => ConsolePlatform.ps3,
        };

        // Extract title name
        final nameBytes = <int>[];
        for (int i = 0; i < 128; i++) {
          final b = infoPtr.ref.titleName[i];
          if (b == 0) break;
          nameBytes.add(b);
        }
        final rawTitle = String.fromCharCodes(nameBytes).trim();
        final filename = path.split(Platform.pathSeparator).last.split('.').first;
        final isGeneric = rawTitle.isEmpty ||
            rawTitle.startsWith('PlayStation') ||
            rawTitle.startsWith('Super Nintendo') ||
            rawTitle == 'OmniStation Game';
        final title = isGeneric ? filename : rawTitle;

        AppLogger.info('NativeBridge', 'Native VFS media parsed successfully: "$title" (Platform: ${platform.name})');

        return GameTitle(
          id: path.hashCode.toString(),
          title: title,
          platform: platform,
          path: path,
          serial: 'OMNI00001',
        );
      } catch (e, st) {
        AppLogger.error('NativeBridge', 'Exception in native loadMedia: $e', e, st);
        rethrow;
      } finally {
        calloc.free(pathPtr);
        calloc.free(infoPtr);
      }
    }

    // Fallback parser when dylib not dynamically loaded
    AppLogger.warn('NativeBridge', 'loadMedia: Using filesystem fallback parser for: $path');
    final ext = path.split('.').last.toLowerCase();
    final platform = switch (ext) {
      'sfc' || 'smc' || 'msc' => ConsolePlatform.snes,
      'bin' || 'cue' => ConsolePlatform.ps1,
      'chd' || 'cso' || 'zso' => ConsolePlatform.ps2,
      'zip' => ConsolePlatform.snes,
      _ => ConsolePlatform.ps3,
    };

    final filename = path.split(Platform.pathSeparator).last;
    return GameTitle(
      id: path.hashCode.toString(),
      title: filename.replaceAll('.$ext', ''),
      platform: platform,
      path: path,
      serial: 'OMNI00001',
    );
  }

  Future<EmulationSessionState> getTelemetry() async {
    if (_getTelemetryFn != null) {
      final tPtr = calloc<NativeTelemetryStruct>();
      try {
        _getTelemetryFn!(tPtr);
        return EmulationSessionState(
          status: CoreExecutionState.running,
          fps: tPtr.ref.fps,
          frametimeMs: tPtr.ref.frametimeMs,
          ppuUsage: tPtr.ref.ppuUsage,
          spuUsage: tPtr.ref.spuUsage,
          eeUsage: tPtr.ref.eeUsage,
          gsUsage: tPtr.ref.gsUsage,
          rsxUsage: tPtr.ref.rsxUsage,
          vramMb: tPtr.ref.vramMb,
          nativeTextureId: 1001,
        );
      } catch (e, st) {
        AppLogger.error('NativeBridge', 'Exception fetching native telemetry: $e', e, st);
      } finally {
        calloc.free(tPtr);
      }
    }

    return const EmulationSessionState(
      status: CoreExecutionState.running,
      fps: 60.0,
      frametimeMs: 16.67,
      ppuUsage: 35.0,
      spuUsage: 45.0,
      eeUsage: 25.0,
      gsUsage: 30.0,
      rsxUsage: 40.0,
      vramMb: 512,
      nativeTextureId: 1001,
    );
  }

  bool bootSnes(String romPath) {
    AppLogger.info('NativeBridge', 'bootSnes requested for ROM path: $romPath');
    if (_snesBootFn == null) {
      AppLogger.error('NativeBridge', 'CRITICAL: Cannot boot SNES core: _snesBootFn is null (dylib not loaded!)');
      return false;
    }

    final romFile = File(romPath);
    if (!romFile.existsSync()) {
      AppLogger.error('NativeBridge', 'CRITICAL: ROM file does not exist on disk at: $romPath');
      return false;
    }

    final ptr = romPath.toNativeUtf8();
    try {
      final res = _snesBootFn!(ptr);
      AppLogger.info('NativeBridge', 'snes_boot native return code: $res');
      if (res != 0) {
        final errDesc = getLastErrorDescription();
        AppLogger.error('NativeBridge', 'snes_boot failed in native core: $errDesc (code: $res)');
        return false;
      }
      AppLogger.info('NativeBridge', 'SNES LakeSnes core booted successfully into memory!');
      return true;
    } catch (e, st) {
      AppLogger.error('NativeBridge', 'Exception executing snes_boot: $e', e, st);
      return false;
    } finally {
      calloc.free(ptr);
    }
  }

  bool stepSnesFrame() {
    if (_snesStepFrameFn != null) {
      try {
        final res = _snesStepFrameFn!();
        return res == 0;
      } catch (e, st) {
        AppLogger.error('NativeBridge', 'Exception during stepSnesFrame: $e', e, st);
        return false;
      }
    }
    return false;
  }

  Uint8List? getSnesPixels() {
    if (_snesGetFramebufferFn != null && _framebufferPtr != null) {
      try {
        final len = _snesGetFramebufferFn!(_framebufferPtr!, 512 * 480 * 4);
        if (len > 0) {
          return _framebufferPtr!.asTypedList(len);
        }
      } catch (e, st) {
        AppLogger.error('NativeBridge', 'Exception during getSnesPixels: $e', e, st);
      }
    }
    return null;
  }

  void setSnesButton(int button, bool pressed) {
    if (_snesSetButtonFn != null) {
      try {
        AppLogger.debug('NativeBridge', 'Button input event: button=$button, pressed=$pressed');
        _snesSetButtonFn!(button, pressed ? 1 : 0);
      } catch (e) {
        AppLogger.warn('NativeBridge', 'Failed to dispatch button event: $e');
      }
    }
  }

  void stopSnes() {
    AppLogger.info('NativeBridge', 'Stopping active SNES emulation session');
    if (_snesStopFn != null) {
      try {
        _snesStopFn!();
      } catch (e, st) {
        AppLogger.error('NativeBridge', 'Exception during stopSnes: $e', e, st);
      }
    }
  }

  void dispose() {
    AppLogger.info('NativeBridge', 'Disposing NativeBridgeDataSource and freeing raw buffers');
    if (_framebufferPtr != null) {
      calloc.free(_framebufferPtr!);
      _framebufferPtr = null;
    }
  }
}
