import 'dart:developer' as developer;

/// Centralized diagnostic logging engine for OmniStation.
///
/// Outputs formatted, timestamped messages to both standard output (with ANSI
/// colors when terminal support is present) and the Flutter Developer timeline.
class AppLogger {
  AppLogger._();

  static const String _cyan = '\x1B[36m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _red = '\x1B[31m';
  static const String _reset = '\x1B[0m';
  static const String _bold = '\x1B[1m';

  static String _timestamp() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    final s = now.second.toString().padLeft(2, '0');
    final ms = now.millisecond.toString().padLeft(3, '0');
    return '$h:$m:$s.$ms';
  }

  static void debug(String tag, String message) {
    final ts = _timestamp();
    // ignore: avoid_print
    print('$_cyan[$ts] [DEBUG] [OMNI:$tag] $message$_reset');
    developer.log(message, name: 'OMNI:$tag', level: 500);
  }

  static void info(String tag, String message) {
    final ts = _timestamp();
    // ignore: avoid_print
    print('$_green[$ts] [INFO]  [OMNI:$tag] $message$_reset');
    developer.log(message, name: 'OMNI:$tag', level: 800);
  }

  static void warn(String tag, String message) {
    final ts = _timestamp();
    // ignore: avoid_print
    print('$_yellow[$ts] [WARN]  [OMNI:$tag] $message$_reset');
    developer.log(message, name: 'OMNI:$tag', level: 900);
  }

  static void error(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    final ts = _timestamp();
    // ignore: avoid_print
    print('$_red$_bold[$ts] [ERROR] [OMNI:$tag] $message$_reset');
    if (error != null) {
      // ignore: avoid_print
      print('$_red       Reason: $error$_reset');
    }
    if (stackTrace != null) {
      // ignore: avoid_print
      print('$_red$stackTrace$_reset');
    }
    developer.log(
      message,
      name: 'OMNI:$tag',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
