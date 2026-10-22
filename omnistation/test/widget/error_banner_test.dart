import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omnistation/core/di/injection.dart';
import 'package:omnistation/core/error/failures.dart';
import 'package:omnistation/core/l10n/generated/app_localizations.dart';
import 'package:omnistation/presentation/common/error_notification_banner.dart';

void main() {
  group('ErrorNotificationBanner User Notification Tests', () {
    testWidgets(
        'Displays localized error notification banner and dismisses on user tap in Spanish',
        (tester) async {
      final container = ProviderContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es'),
            home: const Scaffold(
              body: Stack(
                children: [
                  Center(child: Text('Main Content')),
                  Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: ErrorNotificationBanner(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Initially no error is present
      expect(find.byType(Card), findsNothing);

      // Trigger an error: IsoDecryptionFailure
      container.read(lastFailureProvider.notifier).state =
          const IsoDecryptionFailure();
      await tester.pumpAndSettle();

      // Verify that the banner is visible with localized Spanish error message
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Error de Emulación'), findsOneWidget);
      expect(find.textContaining('Disco de PS3 encriptado'), findsOneWidget);

      // Tap dismiss icon
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify that error is cleared
      expect(container.read(lastFailureProvider), isNull);
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('Renders localized error in Japanese for FirmwareMissingFailure',
        (tester) async {
      final container = ProviderContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ja'),
            home: const Scaffold(
              body: ErrorNotificationBanner(),
            ),
          ),
        ),
      );

      container.read(lastFailureProvider.notifier).state =
          const FirmwareMissingFailure();
      await tester.pumpAndSettle();

      expect(find.text('エミュレーションエラー'), findsOneWidget);
      expect(find.textContaining('必要なファームウェア'), findsOneWidget);
    });
  });
}
