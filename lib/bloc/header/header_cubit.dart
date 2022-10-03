import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mini_map/constants.dart';
import 'package:mini_map/model/pad.dart';
import 'package:mini_map/repo/nav_repo.dart';

part 'header_state.dart';

class HeaderCubit extends Cubit<HeaderState> {
  HeaderCubit(this._navRepository) : super(const NotNavigating()) {
    _listener = _navRepository.movementStream.listen((event) {
      if (event.isEmpty) {
        emit(const NotNavigating());
      } else {
        var move = event.last;
        var pad = move.padList.lastWhere((element) => element.dest.isNotEmpty,
            orElse: () => Pad.empty);
        var destinaton = pad.dest.first;
        emit(NavigatingState(Constants.destIcons[destinaton.imagePath]!,
            destinaton.desc, _navRepository.getTotalLength().toString()));
      }
    });
  }

  final NavRepository _navRepository;

  late StreamSubscription _listener;

  void cancelNavigation() {
    _navRepository.cancelNav();
  }

  @override
  Future<void> close() {
    _listener.cancel();
    return super.close();
  }
}
