import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:omnistation/main.dart';
import 'package:omnistation/presentation/library/library_screen.dart';
import 'package:omnistation/presentation/storage_manager/storage_screen.dart';
import 'package:omnistation/presentation/trophies/trophies_screen.dart';
import 'package:omnistation/presentation/settings/settings_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('OmniStation App Smoke & Full Navigation Test', (tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: OmniStationApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Initial Screen: Library
    expect(find.byType(LibraryScreen), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    // 2. Navigate to Storage Manager
    await tester.tap(find.byIcon(Icons.sd_storage_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(StorageScreen), findsOneWidget);

    // 3. Navigate to Trophies Screen
    await tester.tap(find.byIcon(Icons.emoji_events_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(TrophiesScreen), findsOneWidget);

    // 4. Navigate to Settings Screen
    await tester.tap(find.byIcon(Icons.settings_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    // 5. Navigate back to Library
    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(LibraryScreen), findsOneWidget);
  });
}
