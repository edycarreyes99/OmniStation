import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupportedLocale {
  final String languageCode;
  final String displayName;
  final bool isRtl;

  const SupportedLocale({
    required this.languageCode,
    required this.displayName,
    this.isRtl = false,
  });
}

class L10nService extends StateNotifier<Locale> {
  static const _prefKey = 'omnistation_active_locale';

  static const List<SupportedLocale> allLanguages = [
    SupportedLocale(languageCode: 'en', displayName: 'English'),
    SupportedLocale(languageCode: 'zh', displayName: '中文 (Mandarin)'),
    SupportedLocale(languageCode: 'es', displayName: 'Español'),
    SupportedLocale(languageCode: 'pt', displayName: 'Português'),
    SupportedLocale(languageCode: 'de', displayName: 'Deutsch'),
    SupportedLocale(languageCode: 'fr', displayName: 'Français'),
    SupportedLocale(languageCode: 'it', displayName: 'Italiano'),
    SupportedLocale(languageCode: 'ja', displayName: '日本語'),
    SupportedLocale(languageCode: 'ko', displayName: '한국어'),
    SupportedLocale(languageCode: 'ar', displayName: 'العربية (Arabic)', isRtl: true),
    SupportedLocale(languageCode: 'hi', displayName: 'हिन्दी (Hindi)'),
    SupportedLocale(languageCode: 'ru', displayName: 'Русский'),
    SupportedLocale(languageCode: 'id', displayName: 'Bahasa Indonesia'),
  ];

  L10nService() : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey);
    if (code != null && allLanguages.any((l) => l.languageCode == code)) {
      state = Locale(code);
    }
  }

  Future<void> setLocale(String languageCode) async {
    if (allLanguages.any((l) => l.languageCode == languageCode)) {
      state = Locale(languageCode);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, languageCode);
    }
  }

  bool get isCurrentRtl {
    return state.languageCode == 'ar';
  }
}

final l10nServiceProvider = StateNotifierProvider<L10nService, Locale>((ref) {
  return L10nService();
});
