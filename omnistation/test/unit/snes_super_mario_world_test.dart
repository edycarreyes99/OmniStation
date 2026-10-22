import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omnistation/core/di/injection.dart';
import 'package:omnistation/domain/entities/game_title.dart';
import 'package:omnistation/domain/entities/emulation_session_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Super Mario World Real Emulation Verification', () {
    const romPath = '/Users/edycarreyes99/Projects/Odynnix/OmniStation/Super Mario World (USA).sfc';

    test('verifies real Super Mario World ROM exists on disk and is valid', () {
      final file = File(romPath);
      expect(file.existsSync(), isTrue, reason: 'Super Mario World ROM must be present');
      expect(file.lengthSync(), greaterThanOrEqualTo(512 * 1024));
    });

    test('loads and boots Super Mario World, stepping frames with real hardware core', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(emulationSessionControllerProvider.notifier);
      final bootSuccess = await controller.loadAndBootGame(romPath);

      expect(bootSuccess, isTrue, reason: 'Super Mario World must boot successfully');
      expect(controller.activeGame, isNotNull);
      expect(controller.activeGame!.platform, equals(ConsolePlatform.snes));

      final state = container.read(emulationSessionControllerProvider);
      expect(state.status, equals(CoreExecutionState.running));
      expect(state.fps, equals(60.0));

      // Test input forwarding (Press B to jump, Start to unpause)
      controller.sendInput(0, true); // B down
      controller.sendInput(0, false); // B up
      controller.sendInput(3, true); // Start down
      controller.sendInput(3, false); // Start up

      // Stop session cleanly
      controller.stop();
      final stoppedState = container.read(emulationSessionControllerProvider);
      expect(stoppedState.status, equals(CoreExecutionState.stopped));
      expect(stoppedState.currentFrame, isNull);
    });
  });
}
