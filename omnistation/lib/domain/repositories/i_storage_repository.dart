import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/memory_card_data.dart';
import '../entities/storage_breakdown.dart';
import '../entities/trophy_data.dart';

abstract interface class IStorageRepository {
  Future<Either<AppFailure, MemoryCardData>> getMemoryCard(int slot, CardType type);
  Future<Either<AppFailure, void>> formatMemoryCard(int slot, CardType type);
  Future<Either<AppFailure, void>> saveState(int slot, int platformId);
  Future<Either<AppFailure, void>> loadState(int slot, int platformId);
  Future<Either<AppFailure, List<TrophyData>>> getTrophies(String npCommId);
  Future<Either<AppFailure, bool>> unlockTrophy(String npCommId, int trophyId);
  Future<Either<AppFailure, StorageBreakdown>> getStorageBreakdown();
  Future<Either<AppFailure, void>> clearCache();
}
