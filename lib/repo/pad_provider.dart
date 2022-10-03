import 'package:mini_map/model/destination.dart';
import 'package:mini_map/model/pad.dart';

abstract class PadProvider {
  List<Pad> getTotalPads();
  List<Destination> getTotalDestinations();
}

class FakePadProvider implements PadProvider {
  static const List<Map<String, Object>> FAKEDATA = [
    {
      "current": 1,
      "link": {
        "east": 2,
        "north": 0,
        "south": 0,
        "west": 0,
      },
      "destinations": ["Exit 1 Stairs"]
    },
    {
      "current": 2,
      "link": {
        "east": 3,
        "north": 0,
        "south": 0,
        "west": 1,
      },
      "destinations": []
    },
    {
      "current": 3,
      "link": {
        "east": 4,
        "north": 0,
        "south": 0,
        "west": 2,
      },
      "destinations": []
    },
    {
      "current": 4,
      "link": {
        "east": 0,
        "north": 0,
        "south": 5,
        "west": 3,
      },
      "destinations": ["Elevator 1"]
    },
    {
      "current": 5,
      "link": {
        "east": 0,
        "north": 4,
        "south": 6,
        "west": 0,
      },
      "destinations": []
    },
    {
      "current": 6,
      "link": {
        "east": 0,
        "north": 5,
        "south": 0,
        "west": 0,
      },
      "destinations": ["Train 1~3"]
    }
  ];

  @override
  List<Pad> getTotalPads() {
    var rawData = FAKEDATA;
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
