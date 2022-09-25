import 'package:equatable/equatable.dart';

class Destination extends Equatable {
  final String desc;
  final String imagePath;
  static const List<Destination> listDest = <Destination>[];

  const Destination({required this.desc, required this.imagePath});

  bool isExist(String desc) {
    return listDest.any((element) => element.desc == desc);
  }

  factory Destination.fromDesc(String desc) {
    return listDest.where((element) => element.desc == desc).first;
  }

  @override
  List<Object?> get props => [desc, imagePath];
}
