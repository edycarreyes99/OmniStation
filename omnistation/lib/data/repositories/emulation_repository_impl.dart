import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/game_title.dart';
import '../../domain/entities/emulation_session_state.dart';
import '../../domain/repositories/i_emulation_repository.dart';
import '../datasources/native_bridge_datasource.dart';

class EmulationRepositoryImpl implements IEmulationRepository {
  final NativeBridgeDataSource _dataSource;

  EmulationRepositoryImpl(this._dataSource);

  @override
  Future<Either<AppFailure, GameTitle>> loadMedia(String path) async {
    try {
      final game = await _dataSource.loadMedia(path);
      return right(game);
    } on AppFailure catch (failure) {
      return left(failure);
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> startEmulation() async {
    try {
      return right(null);
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> pauseEmulation() async {
    return right(null);
  }

  @override
  Future<Either<AppFailure, void>> resumeEmulation() async {
    return right(null);
  }

  @override
  Future<Either<AppFailure, void>> stopEmulation() async {
    return right(null);
  }

  @override
  Future<Either<AppFailure, EmulationSessionState>> pollTelemetry() async {
    try {
      final state = await _dataSource.getTelemetry();
      return right(state);
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  bool bootSnes(String path) => _dataSource.bootSnes(path);

  @override
  bool stepSnesFrame() => _dataSource.stepSnesFrame();

  @override
  Uint8List? getSnesPixels() => _dataSource.getSnesPixels();

  @override
  void setSnesButton(int button, bool pressed) =>
      _dataSource.setSnesButton(button, pressed);

  @override
  void stopSnes() => _dataSource.stopSnes();

  @override
  String getLastErrorDescription() => _dataSource.getLastErrorDescription();
}
