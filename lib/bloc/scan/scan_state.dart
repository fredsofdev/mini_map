part of 'scan_cubit.dart';

abstract class ScanState extends Equatable {
  const ScanState(this.tagCode);
  final String tagCode;
  @override
  List<Object> get props => [tagCode];
}

class ScanningState extends ScanState {
  const ScanningState(super.tagCode);
}

class NotScanning extends ScanState {
  const NotScanning() : super("XX-XX-XX-XX");
}
