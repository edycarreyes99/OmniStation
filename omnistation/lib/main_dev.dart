import 'core/config/app_config.dart';
import 'main.dart';

/// Development entry point for OmniStation.
/// Enables debug logging, JIT fallback mocks, and the performance overlay.
void main() {
  bootstrap(AppConfig.dev);
}
