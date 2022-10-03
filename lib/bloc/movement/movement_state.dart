part of 'movement_cubit.dart';

abstract class MovementState extends Equatable {
  const MovementState(this.movements);
  final List<DirectionView> movements;

  @override
  List<Object> get props => [movements];
}

class EmptyMovement extends MovementState {
  const EmptyMovement() : super(const []);
}

class MovementUpdate extends MovementState {
  const MovementUpdate(super.movements);
}
