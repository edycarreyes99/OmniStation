import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Available application runtime flavors for OmniStation.
enum AppFlavor {
  /// Development environment: Detailed JIT logs, mock engine fallbacks, telemetry overlay.
  dev,

  /// Quality Assurance environment: Production emulation with debug assertions & telemetry.
  qa,

  /// Production environment: Fully optimized, stripped debug output, native release binaries.
  prod,
}

/// Immutable configuration parameters tailored to each build flavor.
class AppConfig {
  final AppFlavor flavor;
  final String appName;
  final bool enableDebugLogging;
  final bool enablePerformanceOverlay;
  final bool enableMockJitEngine;

  const AppConfig({
    required this.flavor,
    required this.appName,
    this.enableDebugLogging = false,
    this.enablePerformanceOverlay = false,
    this.enableMockJitEngine = false,
  });

  /// Development Flavor preset
  static const AppConfig dev = AppConfig(
    flavor: AppFlavor.dev,
    appName: 'OmniStation Dev',
    enableDebugLogging: true,
    enablePerformanceOverlay: true,
    enableMockJitEngine: true,
  );

  /// QA / Staging Flavor preset
  static const AppConfig qa = AppConfig(
    flavor: AppFlavor.qa,
    appName: 'OmniStation QA',
    enableDebugLogging: true,
    enablePerformanceOverlay: false,
    enableMockJitEngine: false,
  );

  /// Production Flavor preset
  static const AppConfig prod = AppConfig(
    flavor: AppFlavor.prod,
    appName: 'OmniStation',
    enableDebugLogging: false,
    enablePerformanceOverlay: false,
    enableMockJitEngine: false,
  );

  bool get isDev => flavor == AppFlavor.dev;
  bool get isQa => flavor == AppFlavor.qa;
  bool get isProd => flavor == AppFlavor.prod;
}

/// Riverpod provider delivering the active [AppConfig] across the widget tree.
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.prod;
});
