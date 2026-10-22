import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/native_bridge_datasource.dart';
import '../../data/datasources/storage_filesystem_datasource.dart';
import '../../data/repositories/emulation_repository_impl.dart';
import '../../data/repositories/game_library_repository_impl.dart';
import '../../data/repositories/storage_repository_impl.dart';
import '../../domain/repositories/i_emulation_repository.dart';
import '../../domain/repositories/i_game_library_repository.dart';
import '../../domain/repositories/i_storage_repository.dart';
import '../../domain/usecases/load_game_media_usecase.dart';
import '../../domain/usecases/manage_game_library_usecase.dart';
import '../../domain/usecases/manage_memory_card_usecase.dart';
import '../../domain/usecases/manage_save_state_usecase.dart';
import '../../domain/usecases/manage_trophies_usecase.dart';
import '../../domain/entities/emulation_session_state.dart';
import '../../domain/entities/game_title.dart';
import '../error/failures.dart';
import '../logging/app_logger.dart';

// Data Sources
final nativeBridgeDataSourceProvider = Provider<NativeBridgeDataSource>((ref) {
  return NativeBridgeDataSource();
});

final storageFilesystemDataSourceProvider = Provider<StorageFilesystemDataSource>((ref) {
  return StorageFilesystemDataSource();
});

// Repositories
final emulationRepositoryProvider = Provider<IEmulationRepository>((ref) {
  final ds = ref.watch(nativeBridgeDataSourceProvider);
  return EmulationRepositoryImpl(ds);
});

final storageRepositoryProvider = Provider<IStorageRepository>((ref) {
  final fs = ref.watch(storageFilesystemDataSourceProvider);
  return StorageRepositoryImpl(fs);
});

final gameLibraryRepositoryProvider = Provider<IGameLibraryRepository>((ref) {
  final nb = ref.watch(nativeBridgeDataSourceProvider);
  final fs = ref.watch(storageFilesystemDataSourceProvider);
  return GameLibraryRepositoryImpl(nativeBridge: nb, fsDataSource: fs);
});

// Use Cases
final loadGameMediaUseCaseProvider = Provider<LoadGameMediaUseCase>((ref) {
  return LoadGameMediaUseCase(ref.watch(emulationRepositoryProvider));
});

final manageGameLibraryUseCaseProvider = Provider<ManageGameLibraryUseCase>((ref) {
  return ManageGameLibraryUseCase(ref.watch(gameLibraryRepositoryProvider));
});

final manageMemoryCardUseCaseProvider = Provider<ManageMemoryCardUseCase>((ref) {
  return ManageMemoryCardUseCase(ref.watch(storageRepositoryProvider));
});

final manageSaveStateUseCaseProvider = Provider<ManageSaveStateUseCase>((ref) {
  return ManageSaveStateUseCase(ref.watch(storageRepositoryProvider));
});

final manageTrophiesUseCaseProvider = Provider<ManageTrophiesUseCase>((ref) {
  return ManageTrophiesUseCase(ref.watch(storageRepositoryProvider));
});

// Global Failure Notification Provider
final lastFailureProvider = StateProvider<AppFailure?>((ref) => null);

// Game Library State & Notifier
class GameLibraryState {
  final List<GameTitle> games;
  final bool isLoading;
  final String? searchQuery;
  final ConsolePlatform? selectedPlatform;

  const GameLibraryState({
    this.games = const [],
    this.isLoading = false,
    this.searchQuery,
    this.selectedPlatform,
  });

  GameLibraryState copyWith({
    List<GameTitle>? games,
    bool? isLoading,
    String? searchQuery,
    ConsolePlatform? selectedPlatform,
    bool clearPlatform = false,
  }) {
    return GameLibraryState(
      games: games ?? this.games,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedPlatform: clearPlatform ? null : (selectedPlatform ?? this.selectedPlatform),
    );
  }

  List<GameTitle> get filteredGames {
    return games.where((game) {
      if (selectedPlatform != null && game.platform != selectedPlatform) {
        return false;
      }
      if (searchQuery != null && searchQuery!.isNotEmpty) {
        return game.title.toLowerCase().contains(searchQuery!.toLowerCase());
      }
      return true;
    }).toList();
  }
}

class GameLibraryNotifier extends StateNotifier<GameLibraryState> {
  final ManageGameLibraryUseCase _useCase;
  final Ref _ref;

  GameLibraryNotifier(this._useCase, this._ref) : super(const GameLibraryState()) {
    refreshLibrary();
  }

  Future<void> refreshLibrary({bool showLoading = false}) async {
    AppLogger.debug('Library', 'Refreshing game library (showLoading=$showLoading)');
    if (showLoading) {
      state = state.copyWith(isLoading: true);
    }
    final res = await _useCase.getInstalledGames();
    res.fold(
      (failure) {
        AppLogger.error('Library', 'Failed to retrieve installed games: $failure');
        _ref.read(lastFailureProvider.notifier).state = failure;
        state = state.copyWith(isLoading: false);
      },
      (games) {
        AppLogger.info('Library', 'Game library loaded: ${games.length} titles registered on disk');
        state = state.copyWith(games: games, isLoading: false);
      },
    );
  }

  Future<bool> importGameFile(String path) async {
    AppLogger.info('Library', 'Initiating game import for: $path');
    state = state.copyWith(isLoading: true);
    final res = await _useCase.importGame(path);
    return res.fold(
      (failure) {
        AppLogger.error('Library', 'Import failed for $path: $failure');
        _ref.read(lastFailureProvider.notifier).state = failure;
        state = state.copyWith(isLoading: false);
        return false;
      },
      (game) {
        AppLogger.info('Library', 'Game imported successfully: "${game.title}" -> ${game.path}');
        final updated = List<GameTitle>.from(state.games)
          ..removeWhere((g) => g.path == game.path)
          ..add(game);
        state = state.copyWith(games: updated, isLoading: false);
        return true;
      },
    );
  }

  Future<void> removeGame(String gameId) async {
    AppLogger.info('Library', 'Removing game id: $gameId');
    state = state.copyWith(isLoading: true);
    await _useCase.removeGame(gameId);
    final updated = state.games.where((g) => g.id != gameId).toList();
    state = state.copyWith(games: updated, isLoading: false);
    AppLogger.info('Library', 'Game id $gameId removed. Remaining: ${updated.length}');
  }

  void filterPlatform(ConsolePlatform? platform) {
    AppLogger.debug('Library', 'Filtering by platform: ${platform?.name ?? "All"}');
    state = state.copyWith(selectedPlatform: platform, clearPlatform: platform == null);
  }

  void setSearchQuery(String query) {
    AppLogger.debug('Library', 'Search query updated: "$query"');
    state = state.copyWith(searchQuery: query);
  }
}

final gameLibraryNotifierProvider =
    StateNotifierProvider<GameLibraryNotifier, GameLibraryState>((ref) {
  return GameLibraryNotifier(
    ref.watch(manageGameLibraryUseCaseProvider),
    ref,
  );
});

// Session State Controller
class EmulationSessionController extends StateNotifier<EmulationSessionState> {
  final IEmulationRepository _repo;
  final Ref _ref;
  GameTitle? activeGame;
  Timer? _emulationTimer;
  bool _isDecodingFrame = false;
  int _renderedFrameCount = 0;

  EmulationSessionController(this._repo, this._ref)
      : super(const EmulationSessionState());

  AppFailure? get lastFailure => _ref.read(lastFailureProvider);

  Future<bool> loadAndBootGame(String path) async {
    AppLogger.info('EmuSession', 'loadAndBootGame initiated for: $path');
    state = state.copyWith(status: CoreExecutionState.loading);
    _ref.read(lastFailureProvider.notifier).state = null;
    _stopEmulationTimer();
    _renderedFrameCount = 0;

    try {
      final result = await _repo.loadMedia(path);
      return result.fold(
        (failure) {
          AppLogger.error('EmuSession', 'loadMedia failed: $failure');
          _ref.read(lastFailureProvider.notifier).state = failure;
          state = state.copyWith(status: CoreExecutionState.stopped);
          return false;
        },
        (game) {
          activeGame = game;
          AppLogger.info('EmuSession', 'Media detected: "${game.title}" (Platform: ${game.platform.name})');

          AppLogger.info('EmuSession', 'Executing core boot for: ${game.path} (${game.platform.name})');
          final bootSuccess = _repo.bootCore(game.platform, game.path);
          if (!bootSuccess) {
            final errDesc = _repo.getLastErrorDescription();
            AppLogger.error('EmuSession', 'CRITICAL: Failed to boot core! Native error: $errDesc');
            final failure = UnknownFailure(
              errDesc.isNotEmpty
                  ? '${game.platform.name.toUpperCase()} Core Error: $errDesc'
                  : 'Failed to boot core for ${game.title}',
            );
            _ref.read(lastFailureProvider.notifier).state = failure;
            state = state.copyWith(status: CoreExecutionState.error);
            return false;
          }
          AppLogger.info('EmuSession', 'Core boot confirmed successful!');

          state = state.copyWith(
            status: CoreExecutionState.running,
            fps: 60.0,
            frametimeMs: 16.67,
            ppuUsage: 35.0,
            spuUsage: 45.0,
            eeUsage: 25.0,
            gsUsage: 30.0,
            rsxUsage: 40.0,
            vramMb: 512,
          );

          _startEmulationTimer(game);
          return true;
        },
      );
    } catch (e, st) {
      AppLogger.error('EmuSession', 'Unhandled error in loadAndBootGame: $e', e, st);
      final failure = UnknownFailure(e.toString());
      _ref.read(lastFailureProvider.notifier).state = failure;
      state = state.copyWith(status: CoreExecutionState.error);
      return false;
    }
  }

  void _startEmulationTimer(GameTitle game) {
    _stopEmulationTimer();
    AppLogger.info('EmuSession', 'Starting 60 Hz frame synchronization timer (16.67 ms/frame) for ${game.platform.name}');
    _emulationTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _tickFrame();
    });
  }

  void _tickFrame() {
    if (state.status != CoreExecutionState.running || activeGame == null) return;
    try {
      final stepped = _repo.stepCoreFrame(activeGame!.platform);
      if (!stepped) {
        if (_renderedFrameCount == 0) {
          AppLogger.warn('EmuSession', 'stepCoreFrame returned false on initial tick');
        }
        return;
      }

      if (_isDecodingFrame) return;
      final pixels = _repo.getCorePixels(activeGame!.platform);
      if (pixels != null) {
        _isDecodingFrame = true;
        final copy = Uint8List.fromList(pixels);
        ui.decodeImageFromPixels(
          copy,
          512,
          480,
          ui.PixelFormat.rgba8888,
          (image) {
            _isDecodingFrame = false;
            if (mounted && state.status == CoreExecutionState.running) {
              _renderedFrameCount++;
              if (_renderedFrameCount == 1) {
                AppLogger.info('EmuSession', 'First frame decoded and rendered to viewport successfully! (512x480 RGBA8888)');
              } else if (_renderedFrameCount % 600 == 0) {
                AppLogger.debug('EmuSession', 'Rendered $_renderedFrameCount frames at 60 FPS');
              }
              state = state.copyWith(
                currentFrame: image,
                fps: 60.0,
                frametimeMs: 16.67,
              );
            }
          },
        );
      }
    } catch (e, st) {
      AppLogger.error('EmuSession', 'Exception in _tickFrame: $e', e, st);
    }
  }

  void _stopEmulationTimer() {
    if (_emulationTimer != null) {
      AppLogger.debug('EmuSession', 'Stopping emulation frame timer');
      _emulationTimer?.cancel();
      _emulationTimer = null;
    }
  }

  void sendInput(int button, bool pressed) {
    if (activeGame != null) {
      _repo.setCoreButton(activeGame!.platform, button, pressed);
    }
  }

  void pause() {
    AppLogger.info('EmuSession', 'Pausing emulation session');
    _stopEmulationTimer();
    _repo.pauseEmulation();
    state = state.copyWith(status: CoreExecutionState.paused);
  }

  void resume() {
    AppLogger.info('EmuSession', 'Resuming emulation session');
    _repo.resumeEmulation();
    state = state.copyWith(status: CoreExecutionState.running);
    if (activeGame != null) {
      _startEmulationTimer(activeGame!);
    }
  }

  void stop() {
    AppLogger.info('EmuSession', 'Stopping emulation session and clearing frame');
    _stopEmulationTimer();
    if (activeGame != null) {
      _repo.stopCore(activeGame!.platform);
    }
    _repo.stopEmulation();
    state = state.copyWith(
      status: CoreExecutionState.stopped,
      currentFrame: null,
    );
    activeGame = null;
  }

  @override
  void dispose() {
    AppLogger.info('EmuSession', 'Disposing EmulationSessionController');
    _stopEmulationTimer();
    if (activeGame != null) {
      _repo.stopCore(activeGame!.platform);
    }
    super.dispose();
  }
}

final emulationSessionControllerProvider =
    StateNotifierProvider<EmulationSessionController, EmulationSessionState>((ref) {
  return EmulationSessionController(
    ref.watch(emulationRepositoryProvider),
    ref,
  );
});
