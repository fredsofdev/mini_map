import 'package:flutter/material.dart';
import 'package:mini_map/model/destination.dart';

class Constants {
  static const Color textColor = Colors.white;
  static const Color textHighlColor = Color(0xFFF9AA33);
  static const Color primary = Color(0xFF344955);
  static const Color primary800 = Color(0xFF232F34);
  static const Color primary600 = Color(0xFF4A6572);

  static const MaterialColor primarySwatch = MaterialColor(0xFF344955, {
    50: Color(0xFF253f4b),
    100: Color(0xFFc8dfea),
    200: Color(0xFFacc8d7),
    300: Color(0xFF8eb1c2),
    400: Color(0xFF779eb2),
    500: Color(0xFF608da2),
    600: Color(0xFF537d90),
    700: Color(0xFF446879),
    800: Color(0xFF365563),
    900: Color(0xFF253f4b)
  });

  static const Map<String, IconData> destIcons = {
    "Elevator": Icons.elevator,
    "Train": Icons.train,
    "Restroom": Icons.wc,
    "Stairs": Icons.stairs
  };

  static const List<Destination> fakeDestiontions = [
    Destination(desc: "Elevator 1", imagePath: "Elevator"),
    Destination(desc: "Elevator 2", imagePath: "Elevator"),
    Destination(desc: "Elevator 3", imagePath: "Elevator"),
    Destination(desc: "Elevator 4", imagePath: "Elevator"),
    Destination(desc: "Train 1~3", imagePath: "Train"),
    Destination(desc: "Train 4~7", imagePath: "Train"),
    Destination(desc: "Train 8~11", imagePath: "Train"),
    Destination(desc: "Restroom West", imagePath: "Restroom"),
    Destination(desc: "Restroom South", imagePath: "Restroom"),
    Destination(desc: "Exit 1 Stairs", imagePath: "Stairs"),
    Destination(desc: "Exit 2 Stairs", imagePath: "Stairs"),
    Destination(desc: "Exit 3 Stairs", imagePath: "Stairs"),
    Destination(desc: "Exit 4 Stairs", imagePath: "Stairs"),
  ];

  static const List<Map<String, dynamic>> FAKEDATA = [
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
}
