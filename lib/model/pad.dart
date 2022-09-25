import 'package:equatable/equatable.dart';
import 'package:mini_map/model/destination.dart';

class Pad extends Equatable {
  final int current;
  final Map<String, String> link;
  final List<Destination> dest;

  const Pad({required this.current, required this.link, required this.dest});

  @override
  List<Object?> get props => [current, link, dest];

  factory Pad.fromMap(Map<String, dynamic> data) {
    return Pad(
        current: data['current'],
        link: data['link'] ?? <String, String>{},
        dest: data['dest'] ?? <String>[]);
  }

  static const empty = Pad(
    current: 0,
    link: <String, String>{},
    dest: <Destination>[],
  );
}
