import 'dart:convert';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/failures.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/game_title.dart';
import '../../domain/repositories/i_game_library_repository.dart';
import '../datasources/native_bridge_datasource.dart';
import '../datasources/storage_filesystem_datasource.dart';

class GameLibraryRepositoryImpl implements IGameLibraryRepository {
  static const String _storageKey = 'omnistation_game_library';
  final NativeBridgeDataSource _nativeBridge;
  final StorageFilesystemDataSource _fsDataSource;

  GameLibraryRepositoryImpl({
    NativeBridgeDataSource? nativeBridge,
    StorageFilesystemDataSource? fsDataSource,
  })  : _nativeBridge = nativeBridge ?? NativeBridgeDataSource(),
        _fsDataSource = fsDataSource ?? StorageFilesystemDataSource();

  @override
  Future<Either<AppFailure, List<GameTitle>>> getInstalledGames() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawList = prefs.getStringList(_storageKey) ?? [];
      final List<GameTitle> validGames = [];
      AppLogger.debug('GameLibraryRepo', 'Reading installed games registry (${rawList.length} total entries)');

      for (final raw in rawList) {
        try {
          final map = jsonDecode(raw) as Map<String, dynamic>;
          final game = GameTitle.fromJson(map);
          // Verify file presence on real disk
          if (File(game.path).existsSync()) {
            validGames.add(game);
          }
        } catch (_) {
          // Skip corrupted entries
        }
      }

      // If count changed due to missing files, update persistent registry
      if (validGames.length != rawList.length) {
        await _saveGameList(validGames);
      }

      return right(validGames);
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, GameTitle>> importGame(String sourcePath) async {
    AppLogger.info('GameLibraryRepo', 'importGame requested for: $sourcePath');
    try {
      final sourceFile = File(sourcePath);
      if (!sourceFile.existsSync()) {
        AppLogger.error('GameLibraryRepo', 'Source media file does not exist: $sourcePath');
        return left(const UnknownFailure('Source media file does not exist on disk'));
      }

      // 1. Detect media header & extract metadata via Native Bridge VFS
      final parsedGame = await _nativeBridge.loadMedia(sourcePath);

      // 2. Prepare destination in OmniStation games directory
      final gamesDir = await _fsDataSource.getGamesDir();
      final fileName = sourcePath.split(Platform.pathSeparator).last;
      final destFile = File('${gamesDir.path}/$fileName');

      // Copy to library folder if not already inside
      if (sourceFile.path != destFile.path) {
        AppLogger.info('GameLibraryRepo', 'Copying ROM from $sourcePath to ${destFile.path}');
        try {
          await sourceFile.copy(destFile.path);
        } catch (_) {
          final bytes = await sourceFile.readAsBytes();
          await destFile.writeAsBytes(bytes);
        }
      }

      final fileSize = destFile.existsSync() ? destFile.lengthSync() : sourceFile.lengthSync();

      final game = parsedGame.copyWith(
        id: '${parsedGame.platform.name}_${destFile.path.hashCode}',
        path: destFile.path,
        fileSizeBytes: fileSize,
        dateAdded: DateTime.now(),
      );

      // 3. Persist to storage registry
      final installedRes = await getInstalledGames();
      final currentList = installedRes.getOrElse((_) => []);
      
      // Remove any existing entry with identical path
      final updatedList = currentList.where((g) => g.path != game.path).toList();
      updatedList.add(game);
      await _saveGameList(updatedList);

      AppLogger.info('GameLibraryRepo', 'Game title "${game.title}" registered in library (${game.path})');
      return right(game);
    } on AppFailure catch (failure) {
      AppLogger.error('GameLibraryRepo', 'AppFailure during importGame: $failure');
      return left(failure);
    } catch (e, st) {
      AppLogger.error('GameLibraryRepo', 'Exception during importGame: $e', e, st);
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> removeGame(String gameId) async {
    AppLogger.info('GameLibraryRepo', 'removeGame: deleting gameId $gameId');
    try {
      final installedRes = await getInstalledGames();
      final currentList = installedRes.getOrElse((_) => []);
      final target = currentList.where((g) => g.id == gameId).firstOrNull;

      if (target != null) {
        final file = File(target.path);
        if (file.existsSync()) {
          try {
            file.deleteSync();
            AppLogger.info('GameLibraryRepo', 'Deleted game file from disk: ${target.path}');
          } catch (e) {
            AppLogger.warn('GameLibraryRepo', 'Failed to delete file ${target.path}: $e');
          }
        }
        final updatedList = currentList.where((g) => g.id != gameId).toList();
        await _saveGameList(updatedList);
      }

      return right(null);
    } catch (e, st) {
      AppLogger.error('GameLibraryRepo', 'Exception in removeGame: $e', e, st);
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<void> _saveGameList(List<GameTitle> games) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = games.map((g) => jsonEncode(g.toJson())).toList();
    await prefs.setStringList(_storageKey, jsonList);
  }
}
