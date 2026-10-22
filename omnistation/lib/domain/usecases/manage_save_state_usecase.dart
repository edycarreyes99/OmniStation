import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../repositories/i_storage_repository.dart';

class ManageSaveStateUseCase {
  final IStorageRepository _repository;

  const ManageSaveStateUseCase(this._repository);

  Future<Either<AppFailure, void>> save(int slot, int platformId) {
    if (slot < 0 || slot > 9) {
      return Future.value(left(const SaveStateVersionFailure('Slot must be between 0 and 9')));
    }
    return _repository.saveState(slot, platformId);
  }

  Future<Either<AppFailure, void>> load(int slot, int platformId) {
    if (slot < 0 || slot > 9) {
      return Future.value(left(const SaveStateVersionFailure('Slot must be between 0 and 9')));
    }
    return _repository.loadState(slot, platformId);
  }
}
