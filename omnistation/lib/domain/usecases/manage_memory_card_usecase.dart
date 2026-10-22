import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/memory_card_data.dart';
import '../entities/storage_breakdown.dart';
import '../repositories/i_storage_repository.dart';

class ManageMemoryCardUseCase {
  final IStorageRepository _repository;

  ManageMemoryCardUseCase(this._repository);

  Future<Either<AppFailure, MemoryCardData>> getCard(int slot, CardType type) {
    return _repository.getMemoryCard(slot, type);
  }

  Future<Either<AppFailure, void>> formatCard(int slot, CardType type) {
    return _repository.formatMemoryCard(slot, type);
  }

  Future<Either<AppFailure, StorageBreakdown>> getStorageBreakdown() {
    return _repository.getStorageBreakdown();
  }

  Future<Either<AppFailure, void>> clearCache() {
    return _repository.clearCache();
  }
}
