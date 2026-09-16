import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omnistation/core/error/failures.dart';
import 'package:omnistation/core/l10n/generated/app_localizations.dart';

void main() {
  group('AppFailure Localization Mapping Tests', () {
    testWidgets('Every failure maps to a distinct localized string in English',
        (tester) async {
      late AppLocalizations l10n;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      const failures = <AppFailure>[
        DiscReadFailure(),
        UdfFsFailure(),
        IsoDecryptionFailure(),
        ParamSfoFailure(),
        SelfDecryptionFailure(),
        PkgRapMissingFailure(),
        FirmwareMissingFailure(),
        MemoryCardCorruptFailure(),
        Ps3SaveDataSignatureFailure(),
        SaveStateVersionFailure(),
        AudioInitFailure(),
        GpuInitFailure(),
        JitAllocationFailure(),
        UnknownFailure(),
      ];

      final localizedMessages = <String>{};
      for (final failure in failures) {
        final msg = failure.toLocalizedMessage(l10n);
        expect(msg.isNotEmpty, isTrue);
        expect(localizedMessages.contains(msg), isFalse,
            reason: 'Duplicate failure message found for ${failure.runtimeType}');
        localizedMessages.add(msg);
      }
    });

    testWidgets('Localized error strings render in Spanish and Japanese',
        (tester) async {
      late AppLocalizations esL10n;
      late AppLocalizations jaL10n;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('es'),
          home: Builder(
            builder: (context) {
              esL10n = AppLocalizations.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      const discFailure = DiscReadFailure();
      expect(discFailure.toLocalizedMessage(esL10n),
          contains('Fallo al leer la imagen de disco'));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ja'),
          home: Builder(
            builder: (context) {
              jaL10n = AppLocalizations.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(discFailure.toLocalizedMessage(jaL10n),
          contains('ディスクイメージの読み込み'));
    });

    testWidgets('All 13 supported languages define all new UI and system keys without null/crash',
        (tester) async {
      final supportedCodes = [
        'en', 'zh', 'es', 'pt', 'de', 'fr', 'it', 'ja', 'ko', 'ar', 'hi', 'ru', 'id'
      ];

      for (final code in supportedCodes) {
        late AppLocalizations l10n;
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(code),
            home: Builder(
              builder: (context) {
                l10n = AppLocalizations.of(context);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(l10n.actionOk.isNotEmpty, isTrue, reason: 'Missing actionOk in $code');
        expect(l10n.actionCancel.isNotEmpty, isTrue, reason: 'Missing actionCancel in $code');
        expect(l10n.filterAll.isNotEmpty, isTrue, reason: 'Missing filterAll in $code');
        expect(l10n.actionHideHud.isNotEmpty, isTrue, reason: 'Missing actionHideHud in $code');
        expect(l10n.actionShowHud.isNotEmpty, isTrue, reason: 'Missing actionShowHud in $code');
        expect(l10n.actionSimulateTrophy.isNotEmpty, isTrue, reason: 'Missing actionSimulateTrophy in $code');
        expect(l10n.saveStateSuccess(0).isNotEmpty, isTrue, reason: 'Missing saveStateSuccess in $code');
        expect(l10n.loadStateSuccess(0).isNotEmpty, isTrue, reason: 'Missing loadStateSuccess in $code');
        expect(l10n.trophyGrandMaster.isNotEmpty, isTrue, reason: 'Missing trophyGrandMaster in $code');
        expect(l10n.unitMilliseconds('16.7').isNotEmpty, isTrue, reason: 'Missing unitMilliseconds in $code');
        expect(l10n.percentFormat(50).isNotEmpty, isTrue, reason: 'Missing percentFormat in $code');
        expect(l10n.statusRtlActive.isNotEmpty, isTrue, reason: 'Missing statusRtlActive in $code');
        expect(l10n.tagRtl.isNotEmpty, isTrue, reason: 'Missing tagRtl in $code');
        expect(l10n.settingsGraphicsScaleDesc.isNotEmpty, isTrue, reason: 'Missing settingsGraphicsScaleDesc in $code');
        expect(l10n.settingsResNative.isNotEmpty, isTrue, reason: 'Missing settingsResNative in $code');
        expect(l10n.settingsRes1440p.isNotEmpty, isTrue, reason: 'Missing settingsRes1440p in $code');
        expect(l10n.settingsRes4k.isNotEmpty, isTrue, reason: 'Missing settingsRes4k in $code');
        expect(l10n.settingsRes8k.isNotEmpty, isTrue, reason: 'Missing settingsRes8k in $code');
        expect(l10n.settingsShaderDesc.isNotEmpty, isTrue, reason: 'Missing settingsShaderDesc in $code');
        expect(l10n.storagePs1Capacity.isNotEmpty, isTrue, reason: 'Missing storagePs1Capacity in $code');
        expect(l10n.storagePs2Capacity.isNotEmpty, isTrue, reason: 'Missing storagePs2Capacity in $code');
        expect(l10n.storagePfdValid.isNotEmpty, isTrue, reason: 'Missing storagePfdValid in $code');
        expect(l10n.storagePs3HddPath.isNotEmpty, isTrue, reason: 'Missing storagePs3HddPath in $code');
        expect(l10n.storagePs3HddUsage('5.2', '160').isNotEmpty, isTrue, reason: 'Missing storagePs3HddUsage in $code');
        expect(l10n.trophyPioneerTitle.isNotEmpty, isTrue, reason: 'Missing trophyPioneerTitle in $code');
        expect(l10n.trophyVeteranTitle.isNotEmpty, isTrue, reason: 'Missing trophyVeteranTitle in $code');
        expect(l10n.trophyCellMasterTitle.isNotEmpty, isTrue, reason: 'Missing trophyCellMasterTitle in $code');
        expect(l10n.trophyArchitectTitle.isNotEmpty, isTrue, reason: 'Missing trophyArchitectTitle in $code');
        expect(l10n.btnSelect.isNotEmpty, isTrue, reason: 'Missing btnSelect in $code');
        expect(l10n.btnStart.isNotEmpty, isTrue, reason: 'Missing btnStart in $code');
        expect(l10n.btnL1.isNotEmpty, isTrue, reason: 'Missing btnL1 in $code');
        expect(l10n.btnL2.isNotEmpty, isTrue, reason: 'Missing btnL2 in $code');
        expect(l10n.btnR1.isNotEmpty, isTrue, reason: 'Missing btnR1 in $code');
        expect(l10n.btnR2.isNotEmpty, isTrue, reason: 'Missing btnR2 in $code');
      }
    });
  });
}
