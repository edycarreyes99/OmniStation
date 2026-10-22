import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/game_title.dart';
import '../repositories/i_game_library_repository.dart';

class ManageGameLibraryUseCase {
  final IGameLibraryRepository _repository;

  ManageGameLibraryUseCase(this._repository);

  Future<Either<AppFailure, List<GameTitle>>> getInstalledGames() {
    return _repository.getInstalledGames();
  }

  Future<Either<AppFailure, GameTitle>> importGame(String sourcePath) {
    if (sourcePath.trim().isEmpty) {
      return Future.value(left(const UnknownFailure('Source file path cannot be empty')));
    }
    return _repository.importGame(sourcePath);
  }

  Future<Either<AppFailure, void>> removeGame(String gameId) {
    if (gameId.trim().isEmpty) {
      return Future.value(left(const UnknownFailure('Game ID cannot be empty')));
    }
    return _repository.removeGame(gameId);
  }
}
