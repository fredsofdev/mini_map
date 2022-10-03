import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mini_map/component/bottom_navinfo.dart';
import 'package:mini_map/constants.dart';
import 'package:mini_map/model/movement.dart';
import 'package:mini_map/model/pad.dart';
import 'package:mini_map/repo/nav_repo.dart';

part 'movement_state.dart';

class MovementCubit extends Cubit<MovementState> {
  MovementCubit(this._navRepository) : super(const EmptyMovement()) {
    _listener = _navRepository.movementStream.listen((event) {
      if (event.isEmpty) {
        emit(const EmptyMovement());
      } else {
        emit(MovementUpdate(_mapMovementToView(event).reversed.toList()));
      }
    });
  }

  final NavRepository _navRepository;
  late StreamSubscription _listener;

  List<DirectionView> _mapMovementToView(List<Movement> list) {
    List<DirectionView> viewList = [];
    for (var movement in list) {
      viewList.add(_getView(movement));
    }

    return viewList;
  }

  DirectionView _getView(Movement movement) {
    String text = "";
    IconData iconData;
    switch (movement.action) {
      case ActionState.unknown:
        text = "";
        iconData = Icons.person_pin_circle;
        break;
      case ActionState.forward:
        text = "Forward  ${movement.acLenth.getMeter()} M";
        iconData = Icons.straight;
        break;
      case ActionState.right:
        text = "Right";
        iconData = Icons.turn_right;
        break;
      case ActionState.left:
        text = "Left";
        iconData = Icons.turn_left;
        break;
      case ActionState.stop:
        var pad = movement.padList.lastWhere(
            (element) => element.dest.isNotEmpty,
            orElse: () => Pad.empty);
        var destinaton = pad.dest.first;
        text = destinaton.desc;
        iconData = Constants.destIcons[destinaton.imagePath]!;
    }

    return DirectionView(
      actionIcon: iconData,
      text: text,
      color: movement.state == MoveState.passed
          ? Colors.white38
          : movement.state == MoveState.current
              ? Constants.textHighlColor
              : Colors.white,
    );
  }

  @override
  Future<void> close() {
    _listener.cancel();
    return super.close();
  }
}
