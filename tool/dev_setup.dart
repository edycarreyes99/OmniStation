// ignore_for_file: avoid_print
import 'dart:io';

/// Automated development setup and tri-tier compilation pipeline for OmniStation.
///
/// Compiles in a single command:
/// 1. Native C++23 Hardware Cores (CMake + Metal 3 / Vulkan 1.3 + GoogleTest).
/// 2. Host Infrastructure & C-ABI FFI in Rust Edition 2024 (Cargo workspace + libemu_ffi).
/// 3. Flutter 3.x Impeller Application (clean, pub get, gen-l10n, analyze, test).
///
/// Usage:
///   dart run tool/dev_setup.dart [options]
///   dart tool/dev_setup.dart [options]
///
/// Options:
///   --skip-tests     Skip running test suites (C++, Rust, Flutter).
///   --skip-native    Skip compiling C++ and Rust (process Flutter only).
///   --skip-flutter   Skip Flutter preparation (compile C++ and Rust only).
///   --help, -h       Display this help message.
Future<void> main(List<String> args) async {
  if (args.contains('--help') || args.contains('-h')) {
    _printHelp();
    return;
  }

  final skipTests = args.contains('--skip-tests');
  final skipNative = args.contains('--skip-native');
  final skipFlutter = args.contains('--skip-flutter');

  final rootDir = _findWorkspaceRoot();
  final omnistationDir = Directory('${rootDir.path}/omnistation');

  _printBanner(rootDir.path, omnistationDir.path);

  final stopwatch = Stopwatch()..start();

  // =========================================================================
  // PHASES 1 & 2: Native Compilation (C++23 & Rust Edition 2024)
  // =========================================================================
  if (!skipNative) {
    _printSection('PHASE 1: Native C++23 Cores Compilation (CMake)');
    await _compileCpp(rootDir, skipTests);

    _printSection('PHASE 2: Rust Host Infrastructure Compilation (Cargo)');
    await _compileRust(rootDir, skipTests);

    _printSection('PHASE 3: Dynamic FFI Library Synchronization');
    _syncDynamicLibraries(rootDir, omnistationDir);
  } else {
    print('\x1B[33m[SKIPPED] Native C++ and Rust phases skipped via --skip-native flag\x1B[0m\n');
  }

  // =========================================================================
  // PHASE 3: Flutter Application Environment Setup
  // =========================================================================
  if (!skipFlutter) {
    _printSection('PHASE 4: Flutter Application Environment Setup (omnistation)');
    await _setupFlutter(omnistationDir, skipTests);
  } else {
    print('\x1B[33m[SKIPPED] Flutter phase skipped via --skip-flutter flag\x1B[0m\n');
  }

  stopwatch.stop();
  final elapsedSec = (stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(1);

  print('\n\x1B[32m══════════════════════════════════════════════════════════════════\x1B[0m');
  print('\x1B[32m[SUCCESS] OmniStation has been successfully compiled and configured! (${elapsedSec}s)\x1B[0m');
  print('\x1B[32m══════════════════════════════════════════════════════════════════\x1B[0m\n');
  print('\x1B[36mTo run the application:\x1B[0m');
  print('  cd omnistation');
  print('  flutter run -d macos\n');
}

/// Discovers the OmniStation workspace root regardless of the invocation working directory.
Directory _findWorkspaceRoot() {
  Directory current = Directory.current;
  while (true) {
    final cmake = File('${current.path}/CMakeLists.txt');
    final cargo = File('${current.path}/Cargo.toml');
    final omnistation = Directory('${current.path}/omnistation');
    if (cmake.existsSync() && cargo.existsSync() && omnistation.existsSync()) {
      return current;
    }
    final parent = current.parent;
    if (parent.path == current.path) break;
    current = parent;
  }
  return Directory.current;
}

/// Configures and compiles C++23 cores via CMake and executes GoogleTest validation.
Future<void> _compileCpp(Directory rootDir, bool skipTests) async {
  print('\x1B[36m[INFO] Configuring CMake project...\x1B[0m');
  final configSuccess = await _runCommand(
    'cmake',
    ['-B', 'build', '-S', '.', '-DCMAKE_BUILD_TYPE=Release'],
    workingDirectory: rootDir.path,
  );
  if (!configSuccess) _abort('CMake configuration failed');

  print('\x1B[36m[INFO] Compiling native cores (C++23) in parallel...\x1B[0m');
  final buildSuccess = await _runCommand(
    'cmake',
    ['--build', 'build', '--config', 'Release', '--parallel'],
    workingDirectory: rootDir.path,
  );
  if (!buildSuccess) _abort('CMake C++ compilation failed');

  if (!skipTests) {
    print('\x1B[36m[INFO] Running C++ unit test suite (GoogleTest)...\x1B[0m');
    final testBin = Platform.isWindows
        ? '${rootDir.path}\\build\\cores\\tests\\Release\\omnistation_tests.exe'
        : '${rootDir.path}/build/cores/tests/omnistation_tests';

    if (File(testBin).existsSync()) {
      final testSuccess = await _runCommand(testBin, [], workingDirectory: rootDir.path);
      if (!testSuccess) _abort('C++ unit tests failed (omnistation_tests)');
    } else {
      print('\x1B[33m[WARN] C++ test binary not found at $testBin, skipping...\x1B[0m');
    }
  }
}

/// Compiles Rust workspace crates and the emu_ffi shared dynamic library.
Future<void> _compileRust(Directory rootDir, bool skipTests) async {
  print('\x1B[36m[INFO] Compiling Rust workspace in debug mode...\x1B[0m');
  final buildDevSuccess = await _runCommand(
    'cargo',
    ['build', '--workspace'],
    workingDirectory: rootDir.path,
  );
  if (!buildDevSuccess) _abort('cargo build --workspace failed');

  print('\x1B[36m[INFO] Compiling emu_ffi dynamic library in optimized Release mode...\x1B[0m');
  final buildRelSuccess = await _runCommand(
    'cargo',
    ['build', '--release', '-p', 'emu_ffi'],
    workingDirectory: rootDir.path,
  );
  if (!buildRelSuccess) _abort('cargo build --release -p emu_ffi failed');

  if (!skipTests) {
    print('\x1B[36m[INFO] Verifying Rust linting and unit test suite...\x1B[0m');
    final clippySuccess = await _runCommand(
      'cargo',
      ['clippy', '--workspace', '--all-targets', '--', '-D', 'warnings'],
      workingDirectory: rootDir.path,
    );
    if (!clippySuccess) _abort('cargo clippy failed with warnings or errors');

    final testSuccess = await _runCommand(
      'cargo',
      ['test', '--workspace'],
      workingDirectory: rootDir.path,
    );
    if (!testSuccess) _abort('Rust workspace unit tests failed');
  }
}

/// Synchronizes the compiled dynamic library (dylib/so/dll) with application directories.
void _syncDynamicLibraries(Directory rootDir, Directory omnistationDir) {
  final dylibName = Platform.isMacOS
      ? 'libemu_ffi.dylib'
      : (Platform.isWindows ? 'emu_ffi.dll' : 'libemu_ffi.so');

  final debugDylib = File('${rootDir.path}/target/debug/$dylibName');
  final releaseDylib = File('${rootDir.path}/target/release/$dylibName');

  final activeDylib = debugDylib.existsSync() ? debugDylib : releaseDylib;
  if (!activeDylib.existsSync()) {
    print('\x1B[33m[WARN] $dylibName not found in target/. Skipping synchronization.\x1B[0m');
    return;
  }

  print('\x1B[36m[INFO] Synchronizing $dylibName to application directories...\x1B[0m');

  // Ensure both debug and release directories contain the library
  if (debugDylib.existsSync() && !releaseDylib.existsSync()) {
    releaseDylib.parent.createSync(recursive: true);
    debugDylib.copySync(releaseDylib.path);
  } else if (releaseDylib.existsSync() && !debugDylib.existsSync()) {
    debugDylib.parent.createSync(recursive: true);
    releaseDylib.copySync(debugDylib.path);
  }

  // On macOS, copy into the debug app bundle and ad-hoc codesign
  if (Platform.isMacOS) {
    Process.runSync('codesign', ['-f', '-s', '-', activeDylib.path]);
    final bundleFrameworks = Directory(
      '${omnistationDir.path}/build/macos/Build/Products/Debug/omnistation.app/Contents/Frameworks',
    );
    if (bundleFrameworks.existsSync()) {
      final dest = '${bundleFrameworks.path}/$dylibName';
      activeDylib.copySync(dest);
      Process.runSync('codesign', ['-f', '-s', '-', dest]);
      print('\x1B[32m[SYNC] Copied and signed $dylibName to ${bundleFrameworks.path}\x1B[0m');
    }
    final bundleMacOS = Directory(
      '${omnistationDir.path}/build/macos/Build/Products/Debug/omnistation.app/Contents/MacOS',
    );
    if (bundleMacOS.existsSync()) {
      final dest = '${bundleMacOS.path}/$dylibName';
      activeDylib.copySync(dest);
      Process.runSync('codesign', ['-f', '-s', '-', dest]);
      print('\x1B[32m[SYNC] Copied and signed $dylibName to ${bundleMacOS.path}\x1B[0m');
    }
  }

  // Synchronize and compile Android jniLibs if Android NDK is available
  _syncAndroidJniLibs(rootDir, omnistationDir);
}

/// Synchronizes or compiles Android native libraries for arm64-v8a and x86_64.
void _syncAndroidJniLibs(Directory rootDir, Directory omnistationDir) {
  final jniLibsDir = Directory('${omnistationDir.path}/android/app/src/main/jniLibs');
  final arm64So = File('${jniLibsDir.path}/arm64-v8a/libemu_ffi.so');
  final x86_64So = File('${jniLibsDir.path}/x86_64/libemu_ffi.so');

  // Check for Android NDK in standard locations
  String? ndkPath = Platform.environment['ANDROID_NDK_HOME'];
  if (ndkPath == null || !Directory(ndkPath).existsSync()) {
    final home = Platform.environment['HOME'] ?? '';
    final defaultNdkDir = Directory('$home/Library/Android/sdk/ndk');
    if (defaultNdkDir.existsSync()) {
      final entries = defaultNdkDir.listSync().whereType<Directory>().toList();
      if (entries.isNotEmpty) {
        entries.sort((a, b) => b.path.compareTo(a.path));
        ndkPath = entries.first.path;
      }
    }
  }

  if (ndkPath != null && Directory(ndkPath).existsSync()) {
    final binDir = Directory('$ndkPath/toolchains/llvm/prebuilt/darwin-x86_64/bin');
    if (binDir.existsSync()) {
      final aarch64Clang = File('${binDir.path}/aarch64-linux-android26-clang');
      final x86Clang = File('${binDir.path}/x86_64-linux-android26-clang');

      final commonSources = [
        '-I${rootDir.path}/cores/snes_core',
        '-I${rootDir.path}/cores/snes_core/lake_snes',
        '-I${omnistationDir.path}/android/app/src/main/cpp',
        '${omnistationDir.path}/android/app/src/main/cpp/emu_ffi_bridge.c',
        '${rootDir.path}/cores/snes_core/lake_snes/apu.c',
        '${rootDir.path}/cores/snes_core/lake_snes/cart.c',
        '${rootDir.path}/cores/snes_core/lake_snes/cpu.c',
        '${rootDir.path}/cores/snes_core/lake_snes/dma.c',
        '${rootDir.path}/cores/snes_core/lake_snes/dsp.c',
        '${rootDir.path}/cores/snes_core/lake_snes/input.c',
        '${rootDir.path}/cores/snes_core/lake_snes/ppu.c',
        '${rootDir.path}/cores/snes_core/lake_snes/snes.c',
        '${rootDir.path}/cores/snes_core/lake_snes/snes_other.c',
        '${rootDir.path}/cores/snes_core/lake_snes/spc.c',
        '${rootDir.path}/cores/snes_core/lake_snes/statehandler.c',
        '-llog',
        '-laaudio',
      ];

      if (aarch64Clang.existsSync()) {
        arm64So.parent.createSync(recursive: true);
        final res = Process.runSync(
          aarch64Clang.path,
          [
            '-shared', '-fPIC', '-O3', '-fvisibility=default',
            '-Wno-unused-parameter', '-Wno-sign-compare', '-Wno-unused-function',
            ...commonSources,
            '-o', arm64So.path,
          ],
        );
        if (res.exitCode == 0) {
          print('\x1B[32m[SYNC] Compiled Android arm64-v8a libemu_ffi.so\x1B[0m');
        }
      }

      if (x86Clang.existsSync()) {
        x86_64So.parent.createSync(recursive: true);
        final res = Process.runSync(
          x86Clang.path,
          [
            '-shared', '-fPIC', '-O3', '-fvisibility=default',
            '-Wno-unused-parameter', '-Wno-sign-compare', '-Wno-unused-function',
            ...commonSources,
            '-o', x86_64So.path,
          ],
        );
        if (res.exitCode == 0) {
          print('\x1B[32m[SYNC] Compiled Android x86_64 libemu_ffi.so\x1B[0m');
        }
      }
    }
  } else if (arm64So.existsSync() && x86_64So.existsSync()) {
    print('\x1B[32m[SYNC] Verified existing Android jniLibs (arm64-v8a & x86_64)\x1B[0m');
  }
}

/// Prepares the Flutter project (clean, pub get, gen-l10n, analyze, test).
Future<void> _setupFlutter(Directory omnistationDir, bool skipTests) async {
  final flutterCommands = [
    ['clean'],
    ['pub', 'get'],
    ['gen-l10n'],
    ['analyze'],
  ];

  if (!skipTests) {
    flutterCommands.add(['test']);
  }

  for (final args in flutterCommands) {
    print('\x1B[33m[RUN] flutter ${args.join(" ")}\x1B[0m');
    final success = await _runCommand(
      'flutter',
      args,
      workingDirectory: omnistationDir.path,
    );
    if (!success) {
      _abort('Error executing "flutter ${args.join(" ")}"');
    }
  }
}

/// Executes a process redirecting real-time stdout and stderr streams.
Future<bool> _runCommand(
  String command,
  List<String> args, {
  String? workingDirectory,
}) async {
  final process = await Process.start(
    command,
    args,
    workingDirectory: workingDirectory,
    runInShell: true,
  );

  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);

  final exitCode = await process.exitCode;
  return exitCode == 0;
}

void _printBanner(String rootPath, String flutterPath) {
  print('\x1B[36m╔══════════════════════════════════════════════════════════════════╗\x1B[0m');
  print('\x1B[36m║          OmniStation — Master Development Setup Script           ║\x1B[0m');
  print('\x1B[36m║       C++23 Cores + Rust Host + Flutter 3.x Impeller Engine      ║\x1B[0m');
  print('\x1B[36m╚══════════════════════════════════════════════════════════════════╝\x1B[0m');
  print('Project Root: $rootPath');
  print('Flutter App:  $flutterPath\n');
}

void _printSection(String title) {
  print('\n\x1B[35m▶ $title\x1B[0m');
  print('\x1B[35m${'─' * 66}\x1B[0m');
}

void _abort(String message) {
  print('\n\x1B[31m[ERROR] $message\x1B[0m');
  exit(1);
}

void _printHelp() {
  print('''
Usage: dart run tool/dev_setup.dart [options]

Options:
  --skip-tests     Skip running test suites (C++, Rust, and Flutter).
  --skip-native    Skip compiling C++ and Rust (process Flutter only).
  --skip-flutter   Skip Flutter preparation (compile C++ and Rust only).
  --help, -h       Display this help message.

Examples:
  dart run tool/dev_setup.dart
  dart run tool/dev_setup.dart --skip-tests
''');
}
