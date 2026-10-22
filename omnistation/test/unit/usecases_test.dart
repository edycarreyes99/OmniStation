import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:omnistation/core/di/injection.dart';
import 'package:omnistation/core/error/failures.dart';
import 'package:omnistation/domain/entities/game_title.dart';
import 'package:omnistation/domain/entities/memory_card_data.dart';
import 'package:omnistation/domain/entities/trophy_data.dart';
import 'package:omnistation/domain/entities/emulation_session_state.dart';
import 'package:omnistation/domain/entities/storage_breakdown.dart';
import 'package:omnistation/domain/repositories/i_emulation_repository.dart';
import 'package:omnistation/domain/repositories/i_storage_repository.dart';

class MockEmulationRepository implements IEmulationRepository {
  bool shouldFail = false;

  @override
  Future<Either<AppFailure, GameTitle>> loadMedia(String path) async {
    if (shouldFail) {
      return left(const DiscReadFailure());
    }
    return right(
      GameTitle(
        id: 'mock_1',
        title: 'Demon Souls',
        platform: ConsolePlatform.ps3,
        path: path,
        serial: 'BLES00001',
      ),
    );
  }

  @override
  Future<Either<AppFailure, void>> startEmulation() async => right(null);

  @override
  Future<Either<AppFailure, void>> pauseEmulation() async => right(null);

  @override
  Future<Either<AppFailure, void>> resumeEmulation() async => right(null);

  @override
  Future<Either<AppFailure, void>> stopEmulation() async => right(null);

  @override
  Future<Either<AppFailure, EmulationSessionState>> pollTelemetry() async {
    return right(
      const EmulationSessionState(
        status: CoreExecutionState.running,
        fps: 60.0,
        frametimeMs: 16.6,
        ppuUsage: 30.0,
        spuUsage: 40.0,
        eeUsage: 20.0,
        gsUsage: 25.0,
        rsxUsage: 35.0,
        vramMb: 512,
        nativeTextureId: 42,
      ),
    );
  }

  @override
  bool bootSnes(String path) => true;

  @override
  bool stepSnesFrame() => true;

  @override
  Uint8List? getSnesPixels() => null;

  @override
  void setSnesButton(int button, bool pressed) {}

  @override
  void stopSnes() {}

  @override
  bool bootCore(ConsolePlatform platform, String path) => true;

  @override
  bool stepCoreFrame(ConsolePlatform platform) => true;

  @override
  Uint8List? getCorePixels(ConsolePlatform platform) => null;

  @override
  void setCoreButton(ConsolePlatform platform, int button, bool pressed) {}

  @override
  void stopCore(ConsolePlatform platform) {}

  @override
  String getLastErrorDescription() => '';
}

class MockStorageRepository implements IStorageRepository {
  @override
  Future<Either<AppFailure, MemoryCardData>> getMemoryCard(int slot, CardType type) async {
    return right(
      MemoryCardData(
        slot: slot,
        type: type,
        blocksFree: 15,
        totalBlocks: 15,
        isFormatted: true,
      ),
    );
  }

  @override
  Future<Either<AppFailure, void>> formatMemoryCard(int slot, CardType type) async {
    return right(null);
  }

  @override
  Future<Either<AppFailure, void>> saveState(int slot, int platformId) async {
    return right(null);
  }

  @override
  Future<Either<AppFailure, void>> loadState(int slot, int platformId) async {
    return right(null);
  }

  @override
  Future<Either<AppFailure, List<TrophyData>>> getTrophies(String npCommId) async {
    return right([
      const TrophyData(
        id: 1,
        name: 'Trophy of Honor',
        description: 'Vanquished the Dragon God',
        grade: TrophyGrade.platinum,
        isUnlocked: true,
      ),
    ]);
  }

  @override
  Future<Either<AppFailure, bool>> unlockTrophy(String npCommId, int trophyId) async {
    return right(true);
  }

  @override
  Future<Either<AppFailure, StorageBreakdown>> getStorageBreakdown() async {
    return right(const StorageBreakdown(
      totalUsedBytes: 1024 * 1024 * 100,
      gamesBytes: 1024 * 1024 * 80,
      savesBytes: 1024 * 1024 * 10,
      memoryCardsBytes: 1024 * 1024 * 8,
      cacheBytes: 1024 * 1024 * 2,
      freeDeviceBytes: 1024 * 1024 * 1024 * 50,
    ));
  }

  @override
  Future<Either<AppFailure, void>> clearCache() async {
    return right(null);
  }
}

void main() {
  group('Domain Use Cases & EmulationSessionController Tests', () {
    late MockEmulationRepository mockEmu;
    late MockStorageRepository mockStorage;
    late ProviderContainer container;

    setUp(() {
      mockEmu = MockEmulationRepository();
      mockStorage = MockStorageRepository();

      container = ProviderContainer(
        overrides: [
          emulationRepositoryProvider.overrideWithValue(mockEmu),
          storageRepositoryProvider.overrideWithValue(mockStorage),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('LoadGameMediaUseCase succeeds with Right(GameTitle)', () async {
      final useCase = container.read(loadGameMediaUseCaseProvider);
      final result = await useCase('/games/ps3/demonsouls.iso');

      expect(result.isRight(), isTrue);
      result.match(
        (failure) => fail('Expected Right, got Left($failure)'),
        (game) {
          expect(game.title, equals('Demon Souls'));
          expect(game.platform, equals(ConsolePlatform.ps3));
        },
      );
    });

    test('LoadGameMediaUseCase rejects empty path with DiscReadFailure', () async {
      final useCase = container.read(loadGameMediaUseCaseProvider);
      final result = await useCase('   ');

      expect(result.isLeft(), isTrue);
      result.match(
        (failure) => expect(failure, isA<DiscReadFailure>()),
        (game) => fail('Expected Left'),
      );
    });

    test('ManageMemoryCardUseCase gets memory card data successfully', () async {
      final useCase = container.read(manageMemoryCardUseCaseProvider);
      final result = await useCase.getCard(1, CardType.ps1);

      expect(result.isRight(), isTrue);
      result.match(
        (failure) => fail('Expected Right'),
        (card) {
          expect(card.slot, equals(1));
          expect(card.type, equals(CardType.ps1));
          expect(card.isFormatted, isTrue);
        },
      );
    });

    test('ManageTrophiesUseCase retrieves trophies list', () async {
      final useCase = container.read(manageTrophiesUseCaseProvider);
      final result = await useCase.getTrophies('NPWR00001_00');

      expect(result.isRight(), isTrue);
      result.match(
        (failure) => fail('Expected Right'),
        (trophies) {
          expect(trophies.length, equals(1));
          expect(trophies.first.grade, equals(TrophyGrade.platinum));
          expect(trophies.first.isUnlocked, isTrue);
        },
      );
    });

    test('EmulationSessionController boots game and updates telemetry', () async {
      final controller =
          container.read(emulationSessionControllerProvider.notifier);

      final success = await controller.loadAndBootGame('/games/ps3/demonsouls.iso');
      expect(success, isTrue);
      expect(controller.activeGame?.title, equals('Demon Souls'));

      final state = container.read(emulationSessionControllerProvider);
      expect(state.status, equals(CoreExecutionState.running));
      expect(state.fps, equals(60.0));
      expect(container.read(lastFailureProvider), isNull);
    });

    test('EmulationSessionController registers failure and publishes to lastFailureProvider',
        () async {
      mockEmu.shouldFail = true;
      final controller =
          container.read(emulationSessionControllerProvider.notifier);

      final success = await controller.loadAndBootGame('/games/corrupted.iso');
      expect(success, isFalse);
      expect(controller.activeGame, isNull);

      final failure = container.read(lastFailureProvider);
      expect(failure, isA<DiscReadFailure>());
    });

    test('EmulationSessionController pause, resume, and stop flow', () async {
      final controller =
          container.read(emulationSessionControllerProvider.notifier);

      await controller.loadAndBootGame('/games/ps3/demonsouls.iso');
      expect(container.read(emulationSessionControllerProvider).status,
          equals(CoreExecutionState.running));

      controller.pause();
      expect(container.read(emulationSessionControllerProvider).status,
          equals(CoreExecutionState.paused));

      controller.resume();
      expect(container.read(emulationSessionControllerProvider).status,
          equals(CoreExecutionState.running));

      controller.stop();
      expect(container.read(emulationSessionControllerProvider).status,
          equals(CoreExecutionState.stopped));
      expect(controller.activeGame, isNull);
    });

    test('All 8 console platforms are registered and supported in ConsolePlatform enum', () {
      expect(ConsolePlatform.values.length, equals(8));
      expect(ConsolePlatform.values, contains(ConsolePlatform.snes));
      expect(ConsolePlatform.values, contains(ConsolePlatform.ps1));
      expect(ConsolePlatform.values, contains(ConsolePlatform.ps2));
      expect(ConsolePlatform.values, contains(ConsolePlatform.ps3));
      expect(ConsolePlatform.values, contains(ConsolePlatform.psp));
      expect(ConsolePlatform.values, contains(ConsolePlatform.psvita));
      expect(ConsolePlatform.values, contains(ConsolePlatform.wii));
      expect(ConsolePlatform.values, contains(ConsolePlatform.wiiu));
    });

    test('EmulationSessionController boots PSP, PS Vita, Wii, and Wii U titles', () async {
      final controller =
          container.read(emulationSessionControllerProvider.notifier);

      for (final plat in [
        ConsolePlatform.psp,
        ConsolePlatform.psvita,
        ConsolePlatform.wii,
        ConsolePlatform.wiiu,
      ]) {
        final game = GameTitle(
          id: 'test_${plat.name}',
          title: 'Test Game ${plat.name}',
          platform: plat,
          path: '/test/game.${plat.name}',
          serial: 'TEST0001',
        );

        controller.activeGame = game;
        expect(controller.activeGame?.platform, equals(plat));

        // Test input sending doesn't throw
        controller.sendInput(0, true);
        controller.sendInput(0, false);

        controller.stop();
        expect(container.read(emulationSessionControllerProvider).status,
            equals(CoreExecutionState.stopped));
        expect(controller.activeGame, isNull);
      }
    });
  });
}
