import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

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

class FirestoreScanRepository extends ScanRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String currValDoc = "test_1";

  void _startListening() {
    _listener = firestore
        .collection("Current")
        .doc(currValDoc)
        .snapshots()
        .listen((event) {
      _controller.sink.add(event.get("position"));
    });
  }

  final _controller = StreamController<String>.broadcast();

  late StreamSubscription _listener;

  @override
  Stream<String> get padStream => _controller.stream;

  @override
  void startScanning() {
    _startListening();
  }

  @override
  void stopScanning() {
    _listener.cancel();
  }
}
