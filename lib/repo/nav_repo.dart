import 'dart:async';
import 'dart:collection';

import 'package:mini_map/model/destination.dart';
import 'package:mini_map/model/movement.dart';
import 'package:mini_map/model/pad.dart';
import 'package:mini_map/repo/pad_provider.dart';
import 'package:mini_map/repo/scan_repo.dart';

abstract class NavRepository {
  List<Destination> getAllDestinations();
  void startNav(Destination destination);
  int getTotalLength();
  void cancelNav();
  Stream<List<Movement>> get movementStream;
  Stream<Direction> get directionStream;
}

enum Direction { notarget, finding, correct, incorrect }

class NavManagerRepository extends NavRepository {
  final ScanRepository _scanRepository;
  final PadProvider _padProvider;

  List<Destination> allDestinations = [];
  List<Pad> allPads = [];
  List<Pad> route = [];
  Pad currentPos = Pad.empty;
  Pad targetPad = Pad.empty;

  List<Movement> navPath = [];

  NavManagerRepository(this._scanRepository, this._padProvider) {
    _scanRepository.padStream.listen((event) {
      _updateCurrentLocation(event);
    });
    _getTotalData();
  }

  @override
  List<Destination> getAllDestinations() {
    _getTotalData();
    return allDestinations;
  }

  @override
  void cancelNav() {
    route.clear();
    navPath.clear();
    //currentPos = Pad.empty;
    targetPad = Pad.empty;
    _dirController.sink.add(Direction.notarget);
    _controller.sink.add(navPath);
  }

  @override
  int getTotalLength() {
    if (route.isEmpty) return 0;
    if (!route.contains(currentPos)) return 0;
    var index = route.indexOf(currentPos);
    return route.length - index;
  }

  void _getTotalData() {
    allPads = _padProvider.getTotalPads();
    allDestinations = _padProvider.getTotalDestinations();
    currentPos = allPads.last;
  }

  @override
  void startNav(Destination destination) {
    var targetPads = allPads.where((e) => e.dest.contains(destination));
    if (targetPads.isEmpty) return;
    targetPad = targetPads.first;
    if (currentPos == Pad.empty) {
      _dirController.sink.add(Direction.finding);
    } else {
      routeGenerator();
    }
  }

  void _updateCurrentLocation(String code) {
    var current = allPads.where((e) => e.current == int.parse(code));
    if (current.isEmpty) return;
    _updateMovementByCurrent(current.first);
  }

  void _updateMovementByCurrent(Pad next) {
    if (targetPad == Pad.empty) {
      _dirController.sink.add(Direction.notarget);
      currentPos = next;
      return;
    }

    if (route.isEmpty) {
      currentPos = next;
      routeGenerator();
      return;
    }

    if (!route.contains(next)) {
      _dirController.sink.add(Direction.incorrect);
      currentPos = next;
      routeGenerator();
      return;
    }

    var nextInd = route.indexOf(next);
    var currInd = route.indexOf(currentPos);
    if (nextInd < currInd) {
      _dirController.sink.add(Direction.incorrect);
      currentPos = next;
      return;
    }
    bool passed = false;
    for (int index in Iterable.generate(navPath.length - 1)) {
      if (navPath[index].padList.contains(next)) {
        passed = true;
        var move = navPath[index].update(state: MoveState.current);
        var length = move.padList.length - move.padList.indexOf(next);
        move.acLenth.length = length;
        navPath[index] = move;
      } else {
        navPath[index] = navPath[index]
            .update(state: passed ? MoveState.upcoming : MoveState.passed);
      }
    }
    _dirController.sink.add(Direction.correct);
    _controller.sink.add(navPath);
    currentPos = next;
  }

  final _controller = StreamController<List<Movement>>.broadcast();
  @override
  Stream<List<Movement>> get movementStream => _controller.stream;

  final _dirController = StreamController<Direction>.broadcast();
  @override
  Stream<Direction> get directionStream => _dirController.stream;

  void routeGenerator() {
    List<Pad> neighbors = _getNeighbors();
    route = _reconstructPath(neighbors);
    navPath = _mapRouteToMovement();
    _controller.sink.add(navPath);
    _dirController.sink.add(Direction.correct);
  }

  List<Pad> _getNeighbors() {
    var queue = Queue<Pad>();
    queue.addLast(currentPos);

    List<Pad> prev = [];
    while (queue.isNotEmpty) {
      var node = queue.removeFirst();
      var neighbors = allPads
          .where((element) => node.link.values.contains(element.current))
          .where((element) => !prev.contains(element));
      queue.addAll(neighbors);
      prev.add(node);
      if (node == targetPad) queue.clear();
    }
    return prev;
  }

  List<Pad> _reconstructPath(List<Pad> neighbors) {
    if (!neighbors.contains(currentPos) || !neighbors.contains(targetPad)) {
      return [];
    }

    var revNeighb = neighbors.reversed;
    List<Pad> path = [];
    Pad next = revNeighb.first;
    for (Pad node in revNeighb) {
      if (node == next) {
        var neighbors = revNeighb
            .where((element) => node.link.values.contains(element.current))
            .where((element) => !path.contains(element));
        next = neighbors.isNotEmpty ? neighbors.last : Pad.empty;

        var nextKeys = node.link.keys
            .where((element) => path.isNotEmpty
                ? node.link[element] == path.last.current
                : false)
            .toList();

        var dir = Map.of(node.link);
        for (var key in dir.keys) {
          if (!nextKeys.contains(key)) {
            dir[key] = 0;
          }
        }
        node = node.update(link: dir);

        path.add(node);
      }
    }

    return path.reversed.toList();
  }

  List<Movement> _mapRouteToMovement() {
    List<Movement> moves = [];
    String prevDir = "";
    for (var node in route) {
      var dirKey = node.link.keys.singleWhere(
        (element) => node.link[element] != 0,
        orElse: () => "stop",
      );

      if (prevDir == dirKey) {
        if (moves.last.action != ActionState.forward) {
          moves.add(Movement(
              padList: [],
              state: MoveState.upcoming,
              action: ActionState.forward,
              acLenth: ActionLenth(),
              actionDescript: "forward"));
        }

        moves.last.padList.add(node);
      } else {
        if (moves.isNotEmpty) {
          moves.last.acLenth.length = moves.last.padList.length;
        }

        ActionState dirAction = _getAction(prevDir, dirKey);
        moves.add(Movement(
            padList: [node],
            state: MoveState.upcoming,
            action: dirAction,
            acLenth: ActionLenth(),
            actionDescript: dirAction.name));
      }

      prevDir = dirKey;
    }
    moves.first = moves.first.update(state: MoveState.current);
    return moves.reversed.toList();
  }

  ActionState _getAction(String prevDir, String dirKey) {
    if (prevDir == dirKey) {
      return ActionState.forward;
    } else if (dirKey == "stop") {
      return ActionState.stop;
    } else if (prevDir == "") {
      return ActionState.forward;
    } else {
      const Map<String, List<String>> dir = {
        "east": ["north", "south"],
        "south": ["east", "west"],
        "west": ["south", "north"],
        "north": ["west", "east"],
      };

      var indexOfTurn = dir[prevDir]!.indexOf(dirKey);

      if (indexOfTurn == -1) return ActionState.unknown;
      return indexOfTurn == 0 ? ActionState.left : ActionState.right;
    }
  }
}
