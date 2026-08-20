import 'core/config/app_config.dart';
import 'main.dart';

/// Quality Assurance / Staging entry point for OmniStation.
/// Enables telemetry logging with production emulation pipelines.
void main() {
  bootstrap(AppConfig.qa);
}
