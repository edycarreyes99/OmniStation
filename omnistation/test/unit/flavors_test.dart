import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:omnistation/core/config/app_config.dart';
import 'package:omnistation/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Flavors & AppConfig Unit Tests', () {
    test('dev configuration initializes with appropriate debug flags', () {
      const config = AppConfig.dev;
      expect(config.flavor, equals(AppFlavor.dev));
      expect(config.appName, equals('OmniStation Dev'));
      expect(config.isDev, isTrue);
      expect(config.isQa, isFalse);
      expect(config.isProd, isFalse);
      expect(config.enableDebugLogging, isTrue);
      expect(config.enablePerformanceOverlay, isTrue);
      expect(config.enableMockJitEngine, isTrue);
    });

    test('qa configuration initializes with staging flags', () {
      const config = AppConfig.qa;
      expect(config.flavor, equals(AppFlavor.qa));
      expect(config.appName, equals('OmniStation QA'));
      expect(config.isDev, isFalse);
      expect(config.isQa, isTrue);
      expect(config.isProd, isFalse);
      expect(config.enableDebugLogging, isTrue);
      expect(config.enablePerformanceOverlay, isFalse);
      expect(config.enableMockJitEngine, isFalse);
    });

    test('prod configuration initializes with zero overhead release flags', () {
      const config = AppConfig.prod;
      expect(config.flavor, equals(AppFlavor.prod));
      expect(config.appName, equals('OmniStation'));
      expect(config.isDev, isFalse);
      expect(config.isQa, isFalse);
      expect(config.isProd, isTrue);
      expect(config.enableDebugLogging, isFalse);
      expect(config.enablePerformanceOverlay, isFalse);
      expect(config.enableMockJitEngine, isFalse);
    });

    test('appConfigProvider defaults to prod configuration', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final config = container.read(appConfigProvider);
      expect(config.flavor, equals(AppFlavor.prod));
      expect(config.isProd, isTrue);
    });

    test('appConfigProvider can be overridden for dev flavor', () {
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(AppConfig.dev),
        ],
      );
      addTearDown(container.dispose);

      final config = container.read(appConfigProvider);
      expect(config.flavor, equals(AppFlavor.dev));
      expect(config.isDev, isTrue);
      expect(config.appName, equals('OmniStation Dev'));
    });
  });

  group('Flavored OmniStationApp Widget Tests', () {
    testWidgets('OmniStationApp renders successfully with Dev configuration',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(AppConfig.dev),
          ],
          child: const OmniStationApp(),
        ),
      );
      // Performance overlay draws every frame continuously, pump two frames
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(OmniStationApp), findsOneWidget);
      expect(find.byType(MainNavigationShell), findsOneWidget);
    });

    testWidgets('OmniStationApp renders successfully with QA configuration',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(AppConfig.qa),
          ],
          child: const OmniStationApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OmniStationApp), findsOneWidget);
      expect(find.byType(MainNavigationShell), findsOneWidget);
    });

    testWidgets('OmniStationApp renders successfully with Prod configuration',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(AppConfig.prod),
          ],
          child: const OmniStationApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OmniStationApp), findsOneWidget);
      expect(find.byType(MainNavigationShell), findsOneWidget);
    });
  });
}
