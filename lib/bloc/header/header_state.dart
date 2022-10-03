part of 'header_cubit.dart';

abstract class HeaderState extends Equatable {
  const HeaderState(this.iconData, this.destination, this.leftMeters);
  final IconData iconData;
  final String destination;
  final String leftMeters;
  @override
  List<Object> get props => [iconData, destination, leftMeters];
}

class NavigatingState extends HeaderState {
  const NavigatingState(super.iconData, super.destination, super.leftMeters);
}

class NotNavigating extends HeaderState {
  const NotNavigating() : super(Icons.abc, "", "");
}
