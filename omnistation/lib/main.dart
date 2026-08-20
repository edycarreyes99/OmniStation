import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'core/l10n/generated/app_localizations.dart';
import 'core/l10n/l10n_service.dart';
import 'core/logging/app_logger.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'domain/entities/game_title.dart';
import 'presentation/common/error_notification_banner.dart';
import 'presentation/emulator_viewport/viewport_screen.dart';
import 'presentation/library/library_screen.dart';
import 'presentation/settings/settings_screen.dart';
import 'presentation/storage_manager/storage_screen.dart';
import 'presentation/trophies/trophies_screen.dart';

void bootstrap(AppConfig config) {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure global crash and exception handlers
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    AppLogger.error(
      'FlutterFramework',
      details.exceptionAsString(),
      details.exception,
      details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    AppLogger.error('PlatformDispatcher', error.toString(), error, stack);
    return true;
  };

  AppLogger.info(
    'Main',
    'OmniStation engine initialized [Flavor: ${config.flavor.name}, OS: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}, Executable: ${Platform.resolvedExecutable}]',
  );

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
      ],
      child: const OmniStationApp(),
    ),
  );
}

void main() {
  bootstrap(AppConfig.prod);
}

class OmniStationApp extends ConsumerWidget {
  const OmniStationApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLocale = ref.watch(l10nServiceProvider);
    final themeMode = ref.watch(themeControllerProvider);
    final config = ref.watch(appConfigProvider);

    return MaterialApp(
      onGenerateTitle: (context) =>
          config.isProd ? AppLocalizations.of(context).appTitle : config.appName,
      debugShowCheckedModeBanner: config.isDev,
      showPerformanceOverlay: config.enablePerformanceOverlay,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: activeLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends ConsumerStatefulWidget {
  const MainNavigationShell({super.key});

  @override
  ConsumerState<MainNavigationShell> createState() =>
      _MainNavigationShellState();
}

class _MainNavigationShellState extends ConsumerState<MainNavigationShell> {
  int _currentIndex = 0;
  bool _isPlaying = false;
  GameTitle? _activeGame;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRtl = ref.watch(l10nServiceProvider).languageCode == 'ar';

    if (_isPlaying && _activeGame != null) {
      return ViewportScreen(
        onExit: () {
          setState(() {
            _isPlaying = false;
            _activeGame = null;
          });
        },
      );
    }

    final screens = [
      LibraryScreen(
        onGameSelected: (game) {
          setState(() {
            _activeGame = game;
            _isPlaying = true;
          });
        },
      ),
      const StorageScreen(),
      const TrophiesScreen(),
      const SettingsScreen(),
    ];

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: screens,
            ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: ErrorNotificationBanner(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.grid_view_rounded),
              label: l10n.navLibrary,
            ),
            NavigationDestination(
              icon: const Icon(Icons.sd_storage_rounded),
              label: l10n.navStorage,
            ),
            NavigationDestination(
              icon: const Icon(Icons.emoji_events_rounded),
              label: l10n.navTrophies,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_rounded),
              label: l10n.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}
