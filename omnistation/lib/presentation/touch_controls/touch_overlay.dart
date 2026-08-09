import 'package:flutter/material.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';

class TouchOverlay extends StatefulWidget {
  final VoidCallback onPsHomePressed;
  final void Function(int button, bool pressed)? onButtonPressed;

  const TouchOverlay({
    super.key,
    required this.onPsHomePressed,
    this.onButtonPressed,
  });

  @override
  State<TouchOverlay> createState() => _TouchOverlayState();
}

class _TouchOverlayState extends State<TouchOverlay> {
  Offset _leftThumbstickPos = Offset.zero;
  Offset _rightThumbstickPos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Stack(
        children: [
          // Left Side: D-Pad and Left Analog Stick
          Positioned(
            left: 20,
            bottom: 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // D-Pad
                _buildDpad(),
                const SizedBox(height: 20),
                // Left Thumbstick
                _buildThumbstick(
                  pos: _leftThumbstickPos,
                  onPanUpdate: (offset) =>
                      setState(() => _leftThumbstickPos = offset),
                  onPanEnd: () =>
                      setState(() => _leftThumbstickPos = Offset.zero),
                ),
              ],
            ),
          ),

          // Center: Select, PS Home, Start
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPillButton(l10n.btnSelect, 2),
                const SizedBox(width: 16),
                // Dedicated PS Home Button
                GestureDetector(
                  onTap: widget.onPsHomePressed,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xCC1A1D24),
                      border: Border.all(
                        color: AppColors.primaryNeonBlue,
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.home_filled,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _buildPillButton(l10n.btnStart, 3),
              ],
            ),
          ),

          // Right Side: Action Buttons and Right Analog Stick
          Positioned(
            right: 20,
            bottom: 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Action Buttons: Triangle, Square, Circle, Cross
                _buildActionButtons(),
                const SizedBox(height: 20),
                // Right Thumbstick
                _buildThumbstick(
                  pos: _rightThumbstickPos,
                  onPanUpdate: (offset) =>
                      setState(() => _rightThumbstickPos = offset),
                  onPanEnd: () =>
                      setState(() => _rightThumbstickPos = Offset.zero),
                ),
              ],
            ),
          ),

          // Top Triggers: L1, L2, R1, R2
          Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: Row(
              children: [
                _buildShoulderButton(l10n.btnL2, 10),
                const SizedBox(width: 8),
                _buildShoulderButton(l10n.btnL1, 10),
                const Spacer(),
                _buildShoulderButton(l10n.btnR1, 11),
                const SizedBox(width: 8),
                _buildShoulderButton(l10n.btnR2, 11),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDpad() {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0x55000000),
        border: Border.all(color: Colors.white24),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _buildDpadBtn(Icons.arrow_drop_up, 4),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildDpadBtn(Icons.arrow_drop_down, 5),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: _buildDpadBtn(Icons.arrow_left, 6),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildDpadBtn(Icons.arrow_right, 7),
          ),
        ],
      ),
    );
  }

  Widget _buildDpadBtn(IconData icon, int btnCode) {
    return GestureDetector(
      onTapDown: (_) => widget.onButtonPressed?.call(btnCode, true),
      onTapUp: (_) => widget.onButtonPressed?.call(btnCode, false),
      onTapCancel: () => widget.onButtonPressed?.call(btnCode, false),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, color: Colors.white70, size: 32),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0x55000000),
        border: Border.all(color: Colors.white24),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _buildSymbolBtn('▲', Colors.greenAccent, 9),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildSymbolBtn('✖', Colors.blueAccent, 0),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: _buildSymbolBtn('■', Colors.pinkAccent, 1),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildSymbolBtn('●', Colors.redAccent, 8),
          ),
        ],
      ),
    );
  }

  Widget _buildSymbolBtn(String symbol, Color color, int btnCode) {
    return GestureDetector(
      onTapDown: (_) => widget.onButtonPressed?.call(btnCode, true),
      onTapUp: (_) => widget.onButtonPressed?.call(btnCode, false),
      onTapCancel: () => widget.onButtonPressed?.call(btnCode, false),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          symbol,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildThumbstick({
    required Offset pos,
    required Function(Offset) onPanUpdate,
    required VoidCallback onPanEnd,
  }) {
    return GestureDetector(
      onPanUpdate: (details) {
        final local = pos + details.delta;
        final clamped = Offset(
          local.dx.clamp(-35.0, 35.0),
          local.dy.clamp(-35.0, 35.0),
        );
        onPanUpdate(clamped);
      },
      onPanEnd: (_) => onPanEnd(),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0x33000000),
          border: Border.all(color: Colors.white12),
        ),
        child: Center(
          child: Transform.translate(
            offset: pos,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xAAFFFFFF),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillButton(String text, int btnCode) {
    return GestureDetector(
      onTapDown: (_) => widget.onButtonPressed?.call(btnCode, true),
      onTapUp: (_) => widget.onButtonPressed?.call(btnCode, false),
      onTapCancel: () => widget.onButtonPressed?.call(btnCode, false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0x99000000),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white30),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildShoulderButton(String text, int btnCode) {
    return GestureDetector(
      onTapDown: (_) => widget.onButtonPressed?.call(btnCode, true),
      onTapUp: (_) => widget.onButtonPressed?.call(btnCode, false),
      onTapCancel: () => widget.onButtonPressed?.call(btnCode, false),
      child: Container(
        width: 60,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0x88000000),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
