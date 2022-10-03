import 'package:equatable/equatable.dart';
import 'package:mini_map/constants.dart';

class Destination extends Equatable {
  final String desc;
  final String imagePath;

  const Destination({required this.desc, required this.imagePath});

  bool isExist(String desc) {
    return Constants.fakeDestiontions.any((element) => element.desc == desc);
  }

  factory Destination.fromDesc(String desc) {
    return Constants.fakeDestiontions
        .where((element) => element.desc == desc)
        .first;
  }

  @override
  List<Object?> get props => [desc, imagePath];
}
