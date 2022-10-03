import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_map/constants.dart';
import 'package:mini_map/model/destination.dart';
import 'package:mini_map/model/pad.dart';

abstract class PadProvider {
  List<Pad> getTotalPads();
  List<Destination> getTotalDestinations();
}

class FakePadProvider implements PadProvider {
  @override
  List<Pad> getTotalPads() {
    var rawData = Constants.FAKEDATA;
    var pads = <Pad>[];
    for (var element in rawData) {
      pads.add(Pad(
          current: element['current'] as int,
          dest: (element['destinations'] as List)
              .map((entry) => Destination.fromDesc(entry as String))
              .toList(),
          link: element['link'] as Map<String, int>));
    }
    return pads;
  }

  @override
  List<Destination> getTotalDestinations() {
    var allPads = getTotalPads();
    List<Destination> list = <Destination>[];
    for (var element in allPads) {
      list.addAll(element.dest);
    }
    print("Get all destinations " + list.length.toString());
    return list;
  }
}

class FirestorePadProvider implements PadProvider {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String mapDocName = "map_1";

  List<Map<String, dynamic>> list = [];

  FirestorePadProvider() {
    var collectionRef = firestore.collection('MapCollection');
    collectionRef.doc(mapDocName).get().then((docSnapshot) {
      if (docSnapshot.exists) {
        list = (docSnapshot.get('pads') as List)
            .cast<Map<String, dynamic>>()
            .toList();
      } else {
        collectionRef.doc(mapDocName).set({'pads': Constants.FAKEDATA});
        list = Constants.FAKEDATA;
      }
    });
  }

  @override
  List<Destination> getTotalDestinations() {
    var allPads = getTotalPads();
    List<Destination> list = <Destination>[];
    for (var element in allPads) {
      list.addAll(element.dest);
    }
    print("Get all destinations " + list.length.toString());
    return list;
  }

  @override
  List<Pad> getTotalPads() {
    var rawData = list;
    var pads = <Pad>[];
    for (var element in rawData) {
      pads.add(Pad(
          current: element['current'] as int,
          dest: (element['destinations'] as List)
              .map((entry) => Destination.fromDesc(entry as String))
              .toList(),
          link: (element['link'] as Map<String, dynamic>).cast()));
    }
    return pads;
  }
}
