import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/l10n/l10n_service.dart';
import '../../core/theme/theme_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(l10nServiceProvider);
    final currentTheme = ref.watch(themeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navSettings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.palette_outlined),
                      const SizedBox(width: 8),
                      Text(
                        l10n.settingsTheme,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
                    segments: [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text(l10n.settingsThemeSystem),
                        icon: const Icon(Icons.brightness_auto),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text(l10n.settingsThemeLight),
                        icon: const Icon(Icons.light_mode),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text(l10n.settingsThemeDark),
                        icon: const Icon(Icons.dark_mode),
                      ),
                    ],
                    selected: {currentTheme},
                    onSelectionChanged: (newVal) {
                      ref
                          .read(themeControllerProvider.notifier)
                          .setThemeMode(newVal.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 13 Languages Multi-lingual Selector & RTL Indicator
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.translate),
                      const SizedBox(width: 8),
                      Text(
                        l10n.settingsLanguage,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (currentLocale.languageCode == 'ar')
                        Chip(
                          label: Text(l10n.statusRtlActive, style: const TextStyle(fontSize: 11)),
                          backgroundColor: const Color(0x3300E5FF),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: currentLocale.languageCode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: L10nService.allLanguages.map((lang) {
                      return DropdownMenuItem<String>(
                        value: lang.languageCode,
                        child: Row(
                          children: [
                            Text(lang.displayName),
                            if (lang.isRtl) ...[
                              const SizedBox(width: 8),
                              Text(l10n.tagRtl,
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.cyan)),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (newLang) {
                      if (newLang != null) {
                        ref
                            .read(l10nServiceProvider.notifier)
                            .setLocale(newLang);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Graphics Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.speed_rounded),
                      const SizedBox(width: 8),
                      Text(
                        l10n.settingsGraphics,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.settingsInternalResolution),
                    subtitle: Text(l10n.settingsGraphicsScaleDesc),
                    trailing: DropdownButton<String>(
                      value: '2x',
                      items: [
                        DropdownMenuItem(value: '1x', child: Text(l10n.settingsResNative)),
                        DropdownMenuItem(value: '2x', child: Text(l10n.settingsRes1440p)),
                        DropdownMenuItem(value: '4x', child: Text(l10n.settingsRes4k)),
                        DropdownMenuItem(value: '8x', child: Text(l10n.settingsRes8k)),
                      ],
                      onChanged: (_) {},
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.settingsShaderPreset),
                    subtitle: Text(l10n.settingsShaderDesc),
                    trailing: DropdownButton<String>(
                      value: 'crt',
                      items: [
                        DropdownMenuItem(
                            value: 'none', child: Text(l10n.settingsShaderNone)),
                        DropdownMenuItem(
                            value: 'crt', child: Text(l10n.settingsShaderCrt)),
                        DropdownMenuItem(
                            value: 'scanlines',
                            child: Text(l10n.settingsShaderScanlines)),
                      ],
                      onChanged: (_) {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
