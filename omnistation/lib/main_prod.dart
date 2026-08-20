import 'core/config/app_config.dart';
import 'main.dart';

/// Production entry point for OmniStation.
/// Fully optimized, zero debug overhead, native graphics rendering.
void main() {
  bootstrap(AppConfig.prod);
}
