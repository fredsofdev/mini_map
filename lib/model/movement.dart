import 'package:equatable/equatable.dart';
import 'package:mini_map/model/pad.dart';

enum Action { unknown, forward, right, left }

enum MoveState { upcoming, current, passed }

class ActionLenth {
  int length = 0;

  int getMeter() {
    return length ~/ 5;
  }
}

class Movement extends Equatable {
  final Movement nextMove;
  final List<Pad> padList;
  final Action action;
  final String actionDescript;
  final ActionLenth acLenth;
  final MoveState state;

  bool isContains(Pad pad) {
    if (padList.contains(pad)) {
      var cIndex = padList.indexOf(pad);
      acLenth.length = padList.length - cIndex;
      return true;
    }
    return false;
  }

  factory Movement.empty() => Movement(
      nextMove: Movement.empty(),
      action: Action.unknown,
      actionDescript: "",
      acLenth: ActionLenth(),
      state: MoveState.upcoming,
      padList: const <Pad>[]);

  const Movement(
      {required this.padList,
      required this.state,
      required this.nextMove,
      required this.action,
      required this.acLenth,
      required this.actionDescript});
  @override
  List<Object?> get props => [
        padList,
        state,
        nextMove,
        action,
        actionDescript,
      ];
}
