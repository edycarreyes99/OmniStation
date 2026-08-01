import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/memory_card_data.dart';
import '../../domain/entities/storage_breakdown.dart';
import '../../domain/entities/trophy_data.dart';
import '../../domain/repositories/i_storage_repository.dart';
import '../datasources/storage_filesystem_datasource.dart';

class StorageRepositoryImpl implements IStorageRepository {
  final StorageFilesystemDataSource _fsDataSource;

  StorageRepositoryImpl([StorageFilesystemDataSource? fsDataSource])
      : _fsDataSource = fsDataSource ?? StorageFilesystemDataSource();

  @override
  Future<Either<AppFailure, MemoryCardData>> getMemoryCard(int slot, CardType type) async {
    try {
      final card = await _fsDataSource.getMemoryCard(slot, type);
      return right(card);
    } catch (e) {
      return left(MemoryCardCorruptFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> formatMemoryCard(int slot, CardType type) async {
    try {
      await _fsDataSource.formatMemoryCard(slot, type);
      return right(null);
    } catch (e) {
      return left(MemoryCardCorruptFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> saveState(int slot, int platformId) async {
    try {
      final savesDir = await _fsDataSource.getSavesDir();
      final stateFile = File('${savesDir.path}/state_p${platformId}_s$slot.zst');
      await stateFile.writeAsString('ZSTD_SAVE_STATE_V1', flush: true);
      return right(null);
    } catch (e) {
      return left(SaveStateVersionFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> loadState(int slot, int platformId) async {
    return right(null);
  }

  @override
  Future<Either<AppFailure, List<TrophyData>>> getTrophies(String npCommId) async {
    try {
      final trophies = await _fsDataSource.getTrophies();
      return right(trophies);
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, bool>> unlockTrophy(String npCommId, int trophyId) async {
    try {
      final unlocked = await _fsDataSource.unlockTrophy(trophyId);
      return right(unlocked);
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, StorageBreakdown>> getStorageBreakdown() async {
    try {
      final breakdown = await _fsDataSource.getStorageBreakdown();
      return right(breakdown);
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> clearCache() async {
    try {
      await _fsDataSource.clearCache();
      return right(null);
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }
}
