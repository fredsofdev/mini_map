import 'package:equatable/equatable.dart';
import 'package:mini_map/model/pad.dart';

enum ActionState { unknown, forward, right, left, stop }

enum MoveState { upcoming, current, passed }

class ActionLenth {
  int length = 0;

  int getMeter() {
    return length;
  }
}

class Movement extends Equatable {
  final List<Pad> padList;
  final ActionState action;
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
      action: ActionState.unknown,
      actionDescript: "",
      acLenth: ActionLenth(),
      state: MoveState.upcoming,
      padList: const <Pad>[]);

  const Movement(
      {required this.padList,
      required this.state,
      required this.action,
      required this.acLenth,
      required this.actionDescript});

  Movement update({
    ActionLenth? acLenth,
    MoveState? state,
  }) =>
      Movement(
          padList: padList,
          state: state ?? this.state,
          action: action,
          acLenth: acLenth ?? this.acLenth,
          actionDescript: actionDescript);

  @override
  List<Object?> get props => [
        padList,
        state,
        action,
        actionDescript,
      ];
}
