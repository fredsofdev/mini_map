part of 'mark_cubit.dart';

abstract class MarkState extends Equatable {
  const MarkState(this.iconData, this.desc);
  final IconData iconData;
  final String desc;

  @override
  List<Object> get props => [iconData, desc];
}

class MarkInitial extends MarkState {
  const MarkInitial() : super(Icons.share_location, "");
}

class MarkNavigating extends MarkState {
  const MarkNavigating(super.iconData, super.desc);
}

class MarkScanFirst extends MarkState {
  const MarkScanFirst() : super(Icons.add_location_alt, "Scan point");
}

class MarkUTurn extends MarkState {
  const MarkUTurn() : super(Icons.u_turn_left, "Goback");
}
