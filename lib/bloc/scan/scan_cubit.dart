import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mini_map/repo/scan_repo.dart';

part 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit(this._scanRepository) : super(const NotScanning()) {}

  void _startListening() {
    emit(const ScanningState("Scanning ..."));
    _listener = _scanRepository.padStream.listen((event) {
      emit(ScanningState(event));
    });
  }

  void _stopScanning() {
    _listener.cancel();
    emit(const NotScanning());
  }

  void toggleScanning() {
    if (state is NotScanning) {
      _startListening();
    } else {
      _stopScanning();
    }
  }

  final ScanRepository _scanRepository;

  late StreamSubscription _listener;
  @override
  Future<void> close() {
    _listener.cancel();
    return super.close();
  }
}
