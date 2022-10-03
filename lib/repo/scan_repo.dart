import 'dart:async';

import 'package:mini_map/model/pad.dart';

abstract class ScanRepository {
  void startScanning();
  void stopScanning();
  Stream<String> get padStream;
}

class FakeScanRepository extends ScanRepository {
  Timer? timer;

  @override
  void startScanning() {
    if (timer == null || !timer!.isActive) {
      timer = Timer.periodic(const Duration(seconds: 1), ((timer) {
        _controller.sink.add("47-D3-11-08");
      }));
    }
  }

  @override
  void stopScanning() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  final _controller = StreamController<String>.broadcast();

  @override
  Stream<String> get padStream => _controller.stream;
}
