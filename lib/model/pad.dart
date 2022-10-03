import 'package:equatable/equatable.dart';
import 'package:mini_map/model/destination.dart';

class Pad extends Equatable {
  final int current;
  final Map<String, int> link;
  final List<Destination> dest;

  const Pad({required this.current, required this.link, required this.dest});

  @override
  List<Object?> get props => [current, link, dest];

  factory Pad.fromMap(Map<String, dynamic> data) {
    return Pad(
        current: data['current'],
        link: data['link'] ?? {},
        dest: data['dest'] ?? []);
  }

  Pad update({Map<String, int>? link}) =>
      Pad(current: current, link: link ?? this.link, dest: dest);

  static const empty = Pad(
    current: -1,
    link: <String, int>{},
    dest: <Destination>[],
  );
}
