import 'dart:ui' as ui;

enum CoreExecutionState {
  stopped,
  loading,
  running,
  paused,
  error,
}

class EmulationSessionState {
  final CoreExecutionState status;
  final double fps;
  final double frametimeMs;
  final double ppuUsage;
  final double spuUsage;
  final double eeUsage;
  final double gsUsage;
  final double rsxUsage;
  final int vramMb;
  final int? nativeTextureId;
  final ui.Image? currentFrame;

  const EmulationSessionState({
    this.status = CoreExecutionState.stopped,
    this.fps = 0.0,
    this.frametimeMs = 0.0,
    this.ppuUsage = 0.0,
    this.spuUsage = 0.0,
    this.eeUsage = 0.0,
    this.gsUsage = 0.0,
    this.rsxUsage = 0.0,
    this.vramMb = 0,
    this.nativeTextureId,
    this.currentFrame,
  });

  EmulationSessionState copyWith({
    CoreExecutionState? status,
    double? fps,
    double? frametimeMs,
    double? ppuUsage,
    double? spuUsage,
    double? eeUsage,
    double? gsUsage,
    double? rsxUsage,
    int? vramMb,
    int? nativeTextureId,
    ui.Image? currentFrame,
  }) {
    return EmulationSessionState(
      status: status ?? this.status,
      fps: fps ?? this.fps,
      frametimeMs: frametimeMs ?? this.frametimeMs,
      ppuUsage: ppuUsage ?? this.ppuUsage,
      spuUsage: spuUsage ?? this.spuUsage,
      eeUsage: eeUsage ?? this.eeUsage,
      gsUsage: gsUsage ?? this.gsUsage,
      rsxUsage: rsxUsage ?? this.rsxUsage,
      vramMb: vramMb ?? this.vramMb,
      nativeTextureId: nativeTextureId ?? this.nativeTextureId,
      currentFrame: currentFrame ?? this.currentFrame,
    );
  }
}
