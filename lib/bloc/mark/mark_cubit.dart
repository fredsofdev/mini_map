import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mini_map/constants.dart';
import 'package:mini_map/model/movement.dart';
import 'package:mini_map/model/pad.dart';
import 'package:mini_map/repo/nav_repo.dart';

part 'mark_state.dart';

class MarkCubit extends Cubit<MarkState> {
  MarkCubit(this._navRepository) : super(const MarkInitial()) {
    _dirListener = _navRepository.directionStream.listen((event) {
      if (event == Direction.notarget) {
        emit(const MarkInitial());
      } else if (event == Direction.finding) {
        emit(const MarkScanFirst());
      } else if (event == Direction.incorrect) {
        emit(const MarkUTurn());
      }
    });
    _moveListener = _navRepository.movementStream.listen((event) {
      if (event.isNotEmpty) {
        var curMove = event.lastWhere(
            (element) => element.state == MoveState.current,
            orElse: (() => Movement.empty()));
        if (curMove != Movement.empty()) {
          emit(_getNavigation(curMove));
        }
      }
    });
  }

  MarkNavigating _getNavigation(Movement movement) {
    String text = "";
    IconData iconData;
    switch (movement.action) {
      case ActionState.unknown:
        text = "";
        iconData = Icons.person_pin_circle;
        break;
      case ActionState.forward:
        text = "${movement.acLenth.getMeter()} M";
        iconData = Icons.straight;
        break;
      case ActionState.right:
        iconData = Icons.turn_right;
        break;
      case ActionState.left:
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
    return MarkNavigating(iconData, text);
  }

  final NavRepository _navRepository;

  late StreamSubscription _dirListener;
  late StreamSubscription _moveListener;

  @override
  Future<void> close() {
    _dirListener.cancel();
    _moveListener.cancel();
    return super.close();
  }
}
