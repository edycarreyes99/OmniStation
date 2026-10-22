import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/game_title.dart';
import '../entities/emulation_session_state.dart';

abstract interface class IEmulationRepository {
  Future<Either<AppFailure, GameTitle>> loadMedia(String path);
  Future<Either<AppFailure, void>> startEmulation();
  Future<Either<AppFailure, void>> pauseEmulation();
  Future<Either<AppFailure, void>> resumeEmulation();
  Future<Either<AppFailure, void>> stopEmulation();
  Future<Either<AppFailure, EmulationSessionState>> pollTelemetry();

  bool bootSnes(String path);
  bool stepSnesFrame();
  Uint8List? getSnesPixels();
  void setSnesButton(int button, bool pressed);
  void stopSnes();
  String getLastErrorDescription();
}
