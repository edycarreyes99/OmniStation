import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:omnistation/core/error/failures.dart';
import 'package:omnistation/data/datasources/native_bridge_datasource.dart';
import 'package:omnistation/domain/entities/game_title.dart';
import 'package:omnistation/domain/entities/emulation_session_state.dart';

void main() {
  group('NativeBridgeDataSource Unit Tests', () {
    late NativeBridgeDataSource dataSource;

    setUp(() {
      dataSource = NativeBridgeDataSource();
    });

    test('mapErrorCodeToFailure maps all codes 1 through 13 correctly', () {
      expect(dataSource.mapErrorCodeToFailure(1), isA<DiscReadFailure>());
      expect(dataSource.mapErrorCodeToFailure(2), isA<UdfFsFailure>());
      expect(dataSource.mapErrorCodeToFailure(3), isA<IsoDecryptionFailure>());
      expect(dataSource.mapErrorCodeToFailure(4), isA<ParamSfoFailure>());
      expect(dataSource.mapErrorCodeToFailure(5), isA<SelfDecryptionFailure>());
      expect(dataSource.mapErrorCodeToFailure(6), isA<PkgRapMissingFailure>());
      expect(dataSource.mapErrorCodeToFailure(7), isA<FirmwareMissingFailure>());
      expect(dataSource.mapErrorCodeToFailure(8), isA<MemoryCardCorruptFailure>());
      expect(dataSource.mapErrorCodeToFailure(9), isA<Ps3SaveDataSignatureFailure>());
      expect(dataSource.mapErrorCodeToFailure(10), isA<SaveStateVersionFailure>());
      expect(dataSource.mapErrorCodeToFailure(11), isA<AudioInitFailure>());
      expect(dataSource.mapErrorCodeToFailure(12), isA<GpuInitFailure>());
      expect(dataSource.mapErrorCodeToFailure(13), isA<JitAllocationFailure>());
      expect(dataSource.mapErrorCodeToFailure(99), isA<UnknownFailure>());
    });

    test('initialize runs and marks isInitialized', () async {
      final tempDir = Directory.systemTemp.createTempSync('omni_test_storage');
      try {
        await dataSource.initialize(tempDir.path);
        expect(dataSource.isInitialized, isTrue);
      } finally {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      }
    });

    test('loadMedia parses SNES extension correctly in fallback mode', () async {
      final game = await dataSource.loadMedia('/games/snes/ChronoTrigger.sfc');
      expect(game.platform, equals(ConsolePlatform.snes));
      expect(game.title, equals('ChronoTrigger'));
    });

    test('loadMedia parses PS1 cue/bin correctly', () async {
      final game = await dataSource.loadMedia('/games/ps1/MGS.cue');
      expect(game.platform, equals(ConsolePlatform.ps1));
      expect(game.title, equals('MGS'));
    });

    test('loadMedia parses PS2 chd/cso correctly', () async {
      final game = await dataSource.loadMedia('/games/ps2/ShadowOfTheColossus.chd');
      expect(game.platform, equals(ConsolePlatform.ps2));
      expect(game.title, equals('ShadowOfTheColossus'));
    });

    test('loadMedia defaults to PS3 for iso/pkg/eboot', () async {
      final game = await dataSource.loadMedia('/games/ps3/DemonSouls.iso');
      expect(game.platform, equals(ConsolePlatform.ps3));
      expect(game.title, equals('DemonSouls'));
    });

    test('getTelemetry returns valid default state', () async {
      final telemetry = await dataSource.getTelemetry();
      expect(telemetry.status, equals(CoreExecutionState.running));
      expect(telemetry.fps, greaterThanOrEqualTo(0.0));
      expect(telemetry.frametimeMs, greaterThan(0.0));
    });

    test('getLastErrorDescription returns safe string', () {
      final desc = dataSource.getLastErrorDescription();
      expect(desc, isA<String>());
    });
  });
}
