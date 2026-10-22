import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/logging/app_logger.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/emulation_session_state.dart';
import '../../domain/entities/game_title.dart';
import '../touch_controls/touch_overlay.dart';

class ViewportScreen extends ConsumerStatefulWidget {
  final VoidCallback onExit;

  const ViewportScreen({super.key, required this.onExit});

  @override
  ConsumerState<ViewportScreen> createState() => _ViewportScreenState();
}

class _ViewportScreenState extends ConsumerState<ViewportScreen>
    with SingleTickerProviderStateMixin {
  bool _showHud = true;
  bool _showQuickMenu = false;
  bool _showTouchControls = true;
  String? _unlockedTrophyName;
  late AnimationController _trophyAnimController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    AppLogger.info('Viewport', 'ViewportScreen initState: registering focus and controllers');
    _focusNode = FocusNode();
    _trophyAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    AppLogger.info('Viewport', 'ViewportScreen dispose');
    _focusNode.dispose();
    _trophyAnimController.dispose();
    super.dispose();
  }

  void _triggerTrophyAnimation(String trophyName) {
    AppLogger.info('Viewport', 'Trophy animation triggered: $trophyName');
    setState(() => _unlockedTrophyName = trophyName);
    _trophyAnimController.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() => _unlockedTrophyName = null);
      }
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    final isDown = event is KeyDownEvent || event is KeyRepeatEvent;
    final isUp = event is KeyUpEvent;
    if (!isDown && !isUp) return KeyEventResult.ignored;

    final pressed = isDown;
    int? button;

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) {
      button = 4; // Up
    } else if (key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.keyS) {
      button = 5; // Down
    } else if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.keyA) {
      button = 6; // Left
    } else if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.keyD) {
      button = 7; // Right
    } else if (key == LogicalKeyboardKey.keyZ || key == LogicalKeyboardKey.keyJ) {
      button = 0; // B (Jump)
    } else if (key == LogicalKeyboardKey.keyX || key == LogicalKeyboardKey.keyK) {
      button = 8; // A (Spin Jump)
    } else if (key == LogicalKeyboardKey.keyC || key == LogicalKeyboardKey.keyU) {
      button = 1; // Y (Run / Fireball)
    } else if (key == LogicalKeyboardKey.keyV || key == LogicalKeyboardKey.keyI) {
      button = 9; // X
    } else if (key == LogicalKeyboardKey.keyQ || key == LogicalKeyboardKey.keyL) {
      button = 10; // L
    } else if (key == LogicalKeyboardKey.keyE || key == LogicalKeyboardKey.keyP) {
      button = 11; // R
    } else if (key == LogicalKeyboardKey.shiftLeft ||
        key == LogicalKeyboardKey.shiftRight ||
        key == LogicalKeyboardKey.space ||
        key == LogicalKeyboardKey.backspace) {
      button = 2; // Select
    } else if (key == LogicalKeyboardKey.enter) {
      button = 3; // Start
    } else if (key == LogicalKeyboardKey.escape) {
      if (isDown && event is KeyDownEvent) {
        setState(() => _showQuickMenu = !_showQuickMenu);
      }
      return KeyEventResult.handled;
    }

    if (button != null) {
      AppLogger.debug('Viewport', 'Input dispatched: button=$button, pressed=$pressed');
      ref.read(emulationSessionControllerProvider.notifier).sendInput(button, pressed);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(emulationSessionControllerProvider);
    final activeGame =
        ref.read(emulationSessionControllerProvider.notifier).activeGame;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = theme.extension<OmniStationThemeTokens>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Focus(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: Stack(
          children: [
            // 1. Direct Real-Time Hardware Framebuffer / Texture Canvas (60 FPS)
            Center(
              child: AspectRatio(
                aspectRatio: sessionState.currentFrame != null ? (4 / 3) : (16 / 9),
                child: RepaintBoundary(
                  child: sessionState.status == CoreExecutionState.error
                      ? Container(
                          color: const Color(0xFF14161D),
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline_rounded,
                                  size: 64,
                                  color: AppColors.errorStateRed,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.errorUnknown,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  ref.watch(lastFailureProvider)?.message ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                FilledButton.icon(
                                  icon: const Icon(Icons.arrow_back),
                                  label: Text(l10n.actionCancel),
                                  onPressed: () {
                                    ref
                                        .read(emulationSessionControllerProvider.notifier)
                                        .stop();
                                    widget.onExit();
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      : (sessionState.currentFrame != null
                          ? RawImage(
                              image: sessionState.currentFrame,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.none,
                            )
                          : (sessionState.nativeTextureId != null
                              ? Texture(textureId: sessionState.nativeTextureId!)
                              : Container(
                                  color: Colors.black,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              AppColors.cyanAccent,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          l10n.statusBootingKernel,
                                          style: const TextStyle(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))),
                ),
              ),
            ),

          // 2. Telemetry HUD Overlay (Isolated layer for high-frequency stats)
          if (_showHud && sessionState.status == CoreExecutionState.running)
            Positioned(
              top: 40,
              left: 20,
              child: RepaintBoundary(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: tokens?.hudSurface ?? const Color(0xCC1A1D24),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: tokens?.hudBorder ?? const Color(0x4400E5FF),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTelemetryChip(
                          l10n.telemetryFps, sessionState.fps.toStringAsFixed(1)),
                      const SizedBox(width: 12),
                      _buildTelemetryChip(l10n.telemetryFrameTime,
                          l10n.unitMilliseconds(sessionState.frametimeMs.toStringAsFixed(1))),
                      const SizedBox(width: 12),
                      _buildTelemetryChip(l10n.telemetryPpu,
                          l10n.percentFormat(sessionState.ppuUsage.toInt())),
                      const SizedBox(width: 12),
                      _buildTelemetryChip(l10n.telemetrySpu,
                          l10n.percentFormat(sessionState.spuUsage.toInt())),
                      const SizedBox(width: 12),
                      _buildTelemetryChip(l10n.telemetryRsx,
                          l10n.percentFormat(sessionState.rsxUsage.toInt())),
                    ],
                  ),
                ),
              ),
            ),

          // 3. Quick Action Bar (Top Right)
          Positioned(
            top: 40,
            right: 20,
            child: Row(
              children: [
                IconButton.filledTonal(
                  icon: Icon(_showTouchControls
                      ? Icons.touch_app
                      : Icons.touch_app_outlined),
                  onPressed: () =>
                      setState(() => _showTouchControls = !_showTouchControls),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  icon: const Icon(Icons.menu),
                  onPressed: () =>
                      setState(() => _showQuickMenu = !_showQuickMenu),
                ),
              ],
            ),
          ),

          // 4. Touch Controller Overlay (Mobile & Tablet - Isolated high-frequency touch layer)
          if (_showTouchControls)
            Positioned.fill(
              child: RepaintBoundary(
                child: TouchOverlay(
                  platform: ref.watch(emulationSessionControllerProvider.notifier).activeGame?.platform ??
                      ConsolePlatform.snes,
                  onPsHomePressed: () =>
                      setState(() => _showQuickMenu = !_showQuickMenu),
                  onButtonPressed: (button, pressed) {
                    ref
                        .read(emulationSessionControllerProvider.notifier)
                        .sendInput(button, pressed);
                  },
                ),
              ),
            ),

          // 5. In-Game Quick Menu Modal (XMB / Big Picture style)
          if (_showQuickMenu)
            Container(
              color: Colors.black54,
              child: Center(
                child: Card(
                  elevation: 16,
                  child: Container(
                    width: 340,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          activeGame?.title ?? l10n.appTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow),
                          label: Text(l10n.actionResume),
                          onPressed: () =>
                              setState(() => _showQuickMenu = false),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          icon: Icon(_showHud ? Icons.visibility_off : Icons.visibility),
                          label: Text(_showHud ? l10n.actionHideHud : l10n.actionShowHud),
                          onPressed: () {
                            setState(() => _showHud = !_showHud);
                          },
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.save),
                          label: Text(l10n.actionSaveState),
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final message = l10n.saveStateSuccess(0);
                            await ref
                                .read(manageSaveStateUseCaseProvider)
                                .save(0, 4);
                            if (!mounted) return;
                            messenger.showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.restore),
                          label: Text(l10n.actionLoadState),
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final message = l10n.loadStateSuccess(0);
                            await ref
                                .read(manageSaveStateUseCaseProvider)
                                .load(0, 4);
                            if (!mounted) return;
                            messenger.showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.military_tech),
                          label: Text(l10n.actionSimulateTrophy),
                          onPressed: () {
                            _triggerTrophyAnimation(l10n.trophyGrandMaster);
                            setState(() => _showQuickMenu = false);
                          },
                        ),
                        const SizedBox(height: 16),
                        FilledButton.tonal(
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            ref
                                .read(emulationSessionControllerProvider
                                    .notifier)
                                .stop();
                            widget.onExit();
                          },
                          child: Text(l10n.actionStop),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // 6. Animated PS3 Trophy Unlock Popup (Top Center)
          if (_unlockedTrophyName != null)
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Center(
                child: FadeTransition(
                  opacity: _trophyAnimController.drive(
                    CurveTween(curve: Curves.easeInOut),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xEE1A1D24),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.trophyGold,
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66FFD700),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          color: AppColors.trophyGold,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.trophyUnlocked,
                              style: const TextStyle(
                                color: AppColors.trophyGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              _unlockedTrophyName!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
    );
  }

  Widget _buildTelemetryChip(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white60,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
