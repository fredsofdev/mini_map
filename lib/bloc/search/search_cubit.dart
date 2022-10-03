import 'package:bloc/bloc.dart';
import 'package:mini_map/model/destination.dart';
import 'package:mini_map/repo/nav_repo.dart';
import 'package:mini_map/repo/pad_provider.dart';

class SearchCubit extends Cubit<List<Destination>> {
  SearchCubit(this._padProvider, this._navRepository) : super([]) {
    list = _padProvider.getTotalDestinations();
    emit(list);
  }

  List<Destination> list = [];

  void selectDestination(Destination destination) {
    _navRepository.startNav(destination);
  }

  void searchDestination(String keyword) {
    emit(list.where((e) => e.imagePath.contains(keyword)).toList());
  }

  final PadProvider _padProvider;
  final NavRepository _navRepository;
}
