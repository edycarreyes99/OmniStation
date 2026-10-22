import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/trophy_data.dart';
import '../repositories/i_storage_repository.dart';

class ManageTrophiesUseCase {
  final IStorageRepository _repository;

  const ManageTrophiesUseCase(this._repository);

  Future<Either<AppFailure, List<TrophyData>>> getTrophies(String npCommId) {
    return _repository.getTrophies(npCommId);
  }

  Future<Either<AppFailure, bool>> unlock(String npCommId, int trophyId) {
    return _repository.unlockTrophy(npCommId, trophyId);
  }
}
