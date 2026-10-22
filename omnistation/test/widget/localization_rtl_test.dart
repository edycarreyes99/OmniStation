import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omnistation/core/l10n/generated/app_localizations.dart';

void main() {
  group('OmniStation 13-Language & Arabic RTL Localization Tests', () {
    const supportedLocales = [
      Locale('en'),
      Locale('es'),
      Locale('zh'),
      Locale('pt'),
      Locale('de'),
      Locale('fr'),
      Locale('it'),
      Locale('ja'),
      Locale('ko'),
      Locale('ar'),
      Locale('hi'),
      Locale('ru'),
      Locale('id'),
    ];

    for (final locale in supportedLocales) {
      testWidgets('Loads localization without null/crash for locale ${locale.languageCode}',
          (tester) async {
        late AppLocalizations l10n;

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            home: Builder(
              builder: (context) {
                l10n = AppLocalizations.of(context);
                return Scaffold(
                  body: Center(
                    child: Text(l10n.appTitle),
                  ),
                );
              },
            ),
          ),
        );

        expect(l10n.appTitle.isNotEmpty, isTrue);
        expect(l10n.navLibrary.isNotEmpty, isTrue);
        expect(l10n.navSettings.isNotEmpty, isTrue);
        expect(l10n.navStorage.isNotEmpty, isTrue);
        expect(l10n.navTrophies.isNotEmpty, isTrue);
        expect(l10n.actionResume.isNotEmpty, isTrue);
        expect(l10n.actionSaveState.isNotEmpty, isTrue);
        expect(l10n.actionLoadState.isNotEmpty, isTrue);
        expect(l10n.actionStop.isNotEmpty, isTrue);
        expect(l10n.errorDiscRead.isNotEmpty, isTrue);
        expect(l10n.errorFirmwareMissing.isNotEmpty, isTrue);
        expect(l10n.errorIsoDecryption.isNotEmpty, isTrue);
      });
    }

    testWidgets('Arabic locale renders in RTL text direction and correct glyphs',
        (tester) async {
      late BuildContext testContext;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: Builder(
            builder: (context) {
              testContext = context;
              final l10n = AppLocalizations.of(context);
              return Scaffold(
                appBar: AppBar(title: Text(l10n.appTitle)),
                body: Column(
                  children: [
                    Text(l10n.navLibrary),
                    Text(l10n.navStorage),
                    Text(l10n.navTrophies),
                  ],
                ),
              );
            },
          ),
        ),
      );

      final directionality = Directionality.of(testContext);
      expect(directionality, equals(TextDirection.rtl));

      expect(find.text('أومني ستيشن'), findsOneWidget);
      expect(find.text('المكتبة'), findsOneWidget);
      expect(find.text('وحدة التخزين'), findsOneWidget);
      expect(find.text('الجوائز'), findsOneWidget);
    });
  });
}
