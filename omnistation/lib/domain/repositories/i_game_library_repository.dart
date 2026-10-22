import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/game_title.dart';

abstract interface class IGameLibraryRepository {
  /// Retrieves all games currently imported and present on real disk storage.
  Future<Either<AppFailure, List<GameTitle>>> getInstalledGames();

  /// Validates media via VFS, copies the game file into the emulator directory, and records metadata.
  Future<Either<AppFailure, GameTitle>> importGame(String sourcePath);

  /// Deletes the game ROM/image from real disk storage and updates persistent library records.
  Future<Either<AppFailure, void>> removeGame(String gameId);
}
