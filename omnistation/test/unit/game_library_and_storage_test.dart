import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:omnistation/core/di/injection.dart';
import 'package:omnistation/data/datasources/native_bridge_datasource.dart';
import 'package:omnistation/data/datasources/storage_filesystem_datasource.dart';
import 'package:omnistation/data/repositories/game_library_repository_impl.dart';
import 'package:omnistation/data/repositories/storage_repository_impl.dart';
import 'package:omnistation/domain/entities/game_title.dart';
import 'package:omnistation/domain/entities/memory_card_data.dart';
import 'package:omnistation/domain/usecases/manage_game_library_usecase.dart';

void main() {
  late Directory tempDir;
  late StorageFilesystemDataSource fsDataSource;
  late GameLibraryRepositoryImpl gameLibraryRepo;
  late StorageRepositoryImpl storageRepo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('omnistation_real_test_');
    fsDataSource = StorageFilesystemDataSource(tempDir.path);
    gameLibraryRepo = GameLibraryRepositoryImpl(
      nativeBridge: NativeBridgeDataSource(),
      fsDataSource: fsDataSource,
    );
    storageRepo = StorageRepositoryImpl(fsDataSource);
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    }
  });

  group('Real StorageFilesystemDataSource Tests (Zero Mock)', () {
    test('creates and formats real PS1 binary memory card on disk (128 KB)', () async {
      final card = await fsDataSource.formatMemoryCard(1, CardType.ps1);
      expect(card.slot, equals(1));
      expect(card.type, equals(CardType.ps1));
      expect(card.totalBlocks, equals(16));
      expect(card.blocksFree, equals(15));
      expect(card.isFormatted, isTrue);

      final mcDir = await fsDataSource.getMemoryCardsDir();
      final file = File('${mcDir.path}/ps1_card_slot1.mcd');
      expect(file.existsSync(), isTrue);
      expect(file.lengthSync(), equals(131072)); // 128 KB exact

      final bytes = file.readAsBytesSync();
      expect(bytes[0], equals(0x4D)); // 'M'
      expect(bytes[1], equals(0x43)); // 'C'
    });

    test('creates and formats real PS2 binary memory card on disk (8 MB)', () async {
      final card = await fsDataSource.formatMemoryCard(2, CardType.ps2);
      expect(card.slot, equals(2));
      expect(card.type, equals(CardType.ps2));
      expect(card.totalBlocks, equals(8192));
      expect(card.blocksFree, equals(8191));
      expect(card.isFormatted, isTrue);

      final mcDir = await fsDataSource.getMemoryCardsDir();
      final file = File('${mcDir.path}/ps2_card_slot2.vmc');
      expect(file.existsSync(), isTrue);
      expect(file.lengthSync(), equals(8388608)); // 8 MB exact

      final bytes = file.readAsBytesSync();
      expect(String.fromCharCodes(bytes.sublist(0, 4)), equals('Sony'));
    });

    test('calculates real storage breakdown across directory trees', () async {
      // Create a dummy game file in games/
      final gamesDir = await fsDataSource.getGamesDir();
      final gameFile = File('${gamesDir.path}/test_game.smc');
      gameFile.writeAsBytesSync(List.filled(1024 * 512, 0xEA)); // 512 KB

      // Format a card in memory_cards/
      await fsDataSource.formatMemoryCard(1, CardType.ps1);

      final breakdown = await fsDataSource.getStorageBreakdown();
      expect(breakdown.gamesBytes, equals(1024 * 512));
      expect(breakdown.memoryCardsBytes, equals(131072));
      expect(breakdown.totalUsedBytes, equals(1024 * 512 + 131072));
    });

    test('clears real cache directory', () async {
      final cacheDir = await fsDataSource.getCacheDir();
      final cacheFile = File('${cacheDir.path}/shader_cache.bin');
      cacheFile.writeAsStringSync('COMPILED_RSX_SHADERS');
      expect(cacheFile.existsSync(), isTrue);

      await fsDataSource.clearCache();
      expect(cacheFile.existsSync(), isFalse);
    });

    test('persists real trophies to disk and unlocks with real timestamp', () async {
      final trophies = await fsDataSource.getTrophies();
      expect(trophies, isNotEmpty);
      expect(trophies.first.isUnlocked, isFalse);

      final unlocked = await fsDataSource.unlockTrophy(1);
      expect(unlocked, isTrue);

      final reloaded = await fsDataSource.getTrophies();
      final first = reloaded.firstWhere((t) => t.id == 1);
      expect(first.isUnlocked, isTrue);
      expect(first.unlockedAt, isNotNull);
    });

    test('storageRepo delegates formatting and breakdown through repository layer', () async {
      final cardRes = await storageRepo.formatMemoryCard(2, CardType.ps1);
      expect(cardRes.isRight(), isTrue);

      final readRes = await storageRepo.getMemoryCard(2, CardType.ps1);
      expect(readRes.isRight(), isTrue);
      readRes.match(
        (l) => fail('Should not fail'),
        (card) {
          expect(card.isFormatted, isTrue);
          expect(card.slot, equals(2));
        },
      );

      final breakdownRes = await storageRepo.getStorageBreakdown();
      expect(breakdownRes.isRight(), isTrue);

      final clearRes = await storageRepo.clearCache();
      expect(clearRes.isRight(), isTrue);
    });
  });

  group('Real GameLibraryRepository Tests (Zero Mock)', () {
    test('imports real SNES ROM (.smc) and persists to library', () async {
      final sourceFile = File('${tempDir.path}/source_game.smc');
      sourceFile.writeAsBytesSync(List.filled(1024 * 256, 0x00));

      final importRes = await gameLibraryRepo.importGame(sourceFile.path);
      expect(importRes.isRight(), isTrue);

      final game = importRes.getOrElse((_) => throw Exception('Failed import'));
      expect(game.platform, equals(ConsolePlatform.snes));
      expect(game.fileSizeBytes, equals(1024 * 256));

      // File should now be in games directory
      final gamesDir = await fsDataSource.getGamesDir();
      expect(File('${gamesDir.path}/source_game.smc').existsSync(), isTrue);

      // Verify persistence via getInstalledGames
      final listRes = await gameLibraryRepo.getInstalledGames();
      expect(listRes.isRight(), isTrue);
      final installed = listRes.getOrElse((_) => []);
      expect(installed.length, equals(1));
      expect(installed.first.title, equals('source_game'));
    });

    test('imports real ZSNES ROM (.msc) format correctly', () async {
      final sourceFile = File('${tempDir.path}/zsnes_game.msc');
      sourceFile.writeAsBytesSync(List.filled(1024 * 128, 0x00));

      final importRes = await gameLibraryRepo.importGame(sourceFile.path);
      expect(importRes.isRight(), isTrue);

      final game = importRes.getOrElse((_) => throw Exception('Failed import'));
      expect(game.platform, equals(ConsolePlatform.snes));
    });

    test('removes game from disk and library registry', () async {
      final sourceFile = File('${tempDir.path}/to_delete.smc');
      sourceFile.writeAsBytesSync(List.filled(1024 * 64, 0x00));

      final importRes = await gameLibraryRepo.importGame(sourceFile.path);
      final game = importRes.getOrElse((_) => throw Exception('Failed import'));

      await gameLibraryRepo.removeGame(game.id);

      final listRes = await gameLibraryRepo.getInstalledGames();
      final installed = listRes.getOrElse((_) => []);
      expect(installed.any((g) => g.id == game.id), isFalse);
    });
  });

  group('ManageGameLibraryUseCase & GameLibraryNotifier Tests', () {
    test('use case rejects empty path with DiscReadFailure', () async {
      final useCase = ManageGameLibraryUseCase(gameLibraryRepo);
      final res = await useCase.importGame('');
      expect(res.isLeft(), isTrue);
    });

    test('notifier manages filter by platform and search query', () async {
      final useCase = ManageGameLibraryUseCase(gameLibraryRepo);
      final container = ProviderContainer(
        overrides: [
          manageGameLibraryUseCaseProvider.overrideWithValue(useCase),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(gameLibraryNotifierProvider.notifier);

      // Import two games
      final snesFile = File('${tempDir.path}/Chrono_Trigger.smc');
      snesFile.writeAsBytesSync(List.filled(1024, 0));
      await notifier.importGameFile(snesFile.path);

      final ps1File = File('${tempDir.path}/Final_Fantasy_VII.bin');
      ps1File.writeAsBytesSync(List.filled(1024, 0));
      await notifier.importGameFile(ps1File.path);

      // Verify filtered games by platform
      notifier.filterPlatform(ConsolePlatform.snes);
      var state = container.read(gameLibraryNotifierProvider);
      expect(state.filteredGames.length, equals(1));
      expect(state.filteredGames.first.platform, equals(ConsolePlatform.snes));

      // Verify search query filter
      notifier.filterPlatform(null);
      notifier.setSearchQuery('Final');
      state = container.read(gameLibraryNotifierProvider);
      expect(state.filteredGames.length, equals(1));
      expect(state.filteredGames.first.title, contains('Final'));
    });
  });
}
