import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mini_map/model/movement.dart';
import 'package:mini_map/model/pad.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(const MapState()) {
    on<MapEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
