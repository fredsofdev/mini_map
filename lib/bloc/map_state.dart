part of 'map_bloc.dart';

class MapState extends Equatable {
  final List<Movement> movements;
  final bool isCorrect;
  final Pad curPad;

  const MapState({
    this.movements = const <Movement>[],
    this.isCorrect = true,
    this.curPad = Pad.empty,
  });

  MapState updateState({
    List<Movement>? movements,
    bool? isCorrect,
    Pad? curPad,
  }) {
    return MapState(
        isCorrect: isCorrect ?? this.isCorrect,
        curPad: curPad ?? this.curPad,
        movements: movements ?? this.movements);
  }

  @override
  List<Object?> get props => [movements, isCorrect, curPad];
}
