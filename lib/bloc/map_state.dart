part of 'map_bloc.dart';

class MapState extends Equatable {
  final List<Movement> movements;
  final List<Destination> destinations;
  final bool isCorrect;
  final Pad curPad;

  const MapState(
      {this.movements = const <Movement>[],
      this.isCorrect = true,
      this.curPad = Pad.empty,
      this.destinations = const <Destination>[]});

  MapState updateState({
    List<Destination>? destinations,
    List<Movement>? movements,
    bool? isCorrect,
    Pad? curPad,
  }) {
    return MapState(
        isCorrect: isCorrect ?? this.isCorrect,
        curPad: curPad ?? this.curPad,
        movements: movements ?? this.movements,
        destinations: destinations ?? this.destinations);
  }

  @override
  List<Object?> get props => [movements, isCorrect, curPad, destinations];
}
