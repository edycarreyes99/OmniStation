import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/game_title.dart';
import '../repositories/i_emulation_repository.dart';

class LoadGameMediaUseCase {
  final IEmulationRepository _repository;

  const LoadGameMediaUseCase(this._repository);

  Future<Either<AppFailure, GameTitle>> call(String mediaPath) {
    if (mediaPath.trim().isEmpty) {
      return Future.value(left(const DiscReadFailure('Path cannot be empty')));
    }
    return _repository.loadMedia(mediaPath);
  }
}
