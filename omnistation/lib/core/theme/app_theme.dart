import 'package:flutter/material.dart';
import 'app_colors.dart';

@immutable
class OmniStationThemeTokens extends ThemeExtension<OmniStationThemeTokens> {
  final Color hudSurface;
  final Color hudBorder;
  final Color trophyBannerGlow;
  final Color telemetryLine;

  const OmniStationThemeTokens({
    required this.hudSurface,
    required this.hudBorder,
    required this.trophyBannerGlow,
    required this.telemetryLine,
  });

  @override
  OmniStationThemeTokens copyWith({
    Color? hudSurface,
    Color? hudBorder,
    Color? trophyBannerGlow,
    Color? telemetryLine,
  }) {
    return OmniStationThemeTokens(
      hudSurface: hudSurface ?? this.hudSurface,
      hudBorder: hudBorder ?? this.hudBorder,
      trophyBannerGlow: trophyBannerGlow ?? this.trophyBannerGlow,
      telemetryLine: telemetryLine ?? this.telemetryLine,
    );
  }

  @override
  OmniStationThemeTokens lerp(ThemeExtension<OmniStationThemeTokens>? other, double t) {
    if (other is! OmniStationThemeTokens) return this;
    return OmniStationThemeTokens(
      hudSurface: Color.lerp(hudSurface, other.hudSurface, t)!,
      hudBorder: Color.lerp(hudBorder, other.hudBorder, t)!,
      trophyBannerGlow: Color.lerp(trophyBannerGlow, other.trophyBannerGlow, t)!,
      telemetryLine: Color.lerp(telemetryLine, other.telemetryLine, t)!,
    );
  }
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryNeonBlue,
        surface: AppColors.darkSurface,
        error: AppColors.darkError,
        onSurface: AppColors.darkTextPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        foregroundColor: AppColors.darkTextPrimary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurfaceElevated,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      extensions: const [
        OmniStationThemeTokens(
          hudSurface: Color(0xCC1A1D24),
          hudBorder: Color(0x4400E5FF),
          trophyBannerGlow: AppColors.trophyGold,
          telemetryLine: AppColors.accentCyan,
        ),
      ],
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryNeonBlue,
        surface: AppColors.lightSurface,
        error: AppColors.lightError,
        onSurface: AppColors.lightTextPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        elevation: 0,
        foregroundColor: AppColors.lightTextPrimary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      extensions: const [
        OmniStationThemeTokens(
          hudSurface: Color(0xE6FFFFFF),
          hudBorder: Color(0x330070D1),
          trophyBannerGlow: AppColors.trophyGold,
          telemetryLine: AppColors.primaryNeonBlue,
        ),
      ],
    );
  }
}
