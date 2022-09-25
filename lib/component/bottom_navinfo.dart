import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mini_map/constants.dart';
import 'package:we_slide/we_slide.dart';

class BottomNavInfo extends HookWidget {
  BottomNavInfo({super.key});

  final double panelMin = 60;
  final double panelMax = 600;

  final List<DirectionView> itemList = [
    const DirectionView(
        color: Colors.white, actionIcon: Icons.elevator, text: "Elevator"),
    const DirectionView(
        color: Colors.white, actionIcon: Icons.straight, text: "Forward 30 M"),
    const DirectionView(
        color: Colors.white, actionIcon: Icons.turn_right, text: "Turn Right"),
    const DirectionView(
        color: Colors.white, actionIcon: Icons.straight, text: "Forward 10 M"),
    const DirectionView(
        color: Constants.textHighlColor,
        actionIcon: Icons.turn_left,
        text: "Turn Left"),
    const DirectionView(
        color: Colors.white38, actionIcon: Icons.straight, text: "Forward 5 M"),
    const DirectionView(
        color: Colors.white38,
        actionIcon: Icons.directions_transit,
        text: "Train Exit"),
  ];

  @override
  Widget build(BuildContext context) {
    final val = useRef(WeSlideController(initial: false));
    final isOpen = useState(false);
    useEffect((() {
      val.value.addListener(() {
        isOpen.value = val.value.isOpened;
      });
      return null;
    }), const []);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: WeSlide(
        backgroundColor: Colors.transparent,
        controller: val.value,
        panelMinSize: panelMin,
        panelMaxSize: panelMax,
        hidePanelHeader: false,
        bodyWidth: 0,
        body: Container(),
        panel: Padding(
          padding: EdgeInsets.fromLTRB(0, panelMin, 0, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Constants.primary600,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: itemList.length,
              itemBuilder: (BuildContext context, int index) {
                return itemList[index];
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                indent: 6,
                endIndent: 6,
                height: 6,
                thickness: 2,
              ),
            ),
          ),
        ),
        panelHeader: NavInfoHeader(
          isVisable: true,
          onTap: () {
            val.value.show();
          },
          cancelIcon: IconButton(
            iconSize: 27,
            icon: isOpen.value
                ? const Icon(Icons.arrow_circle_down)
                : const Icon(Icons.highlight_off),
            color: Colors.white,
            onPressed: () {
              if (isOpen.value) {
                val.value.hide();
              } else {
                _cancel(context);
                print("Navigation cancelled");
              }
            },
          ),
        ),
      ),
    );
  }

  void _cancel(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text("Please Confirm"),
            content: const Text("Do you want to cancel navigation?"),
            actions: [
              ElevatedButton(
                  onPressed: (() {
                    Navigator.of(context).pop(true);
                  }),
                  child: const Text("Yes")),
              ElevatedButton(
                  onPressed: (() {
                    Navigator.of(context).pop(false);
                  }),
                  child: const Text("No")),
            ],
          );
        }).then((value) => print(value));
  }
}

class DirectionView extends StatelessWidget {
  const DirectionView(
      {super.key,
      required this.actionIcon,
      required this.text,
      required this.color});

  final IconData actionIcon;
  final String text;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Constants.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          IconButton(
            icon: Icon(actionIcon),
            color: color,
            onPressed: () {},
          ),
          Flexible(
            child: Text(
              text,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class NavInfoHeader extends StatelessWidget {
  const NavInfoHeader(
      {required this.isVisable,
      required this.onTap,
      required this.cancelIcon,
      super.key});

  final bool isVisable;
  final Function onTap;
  final IconButton cancelIcon;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisable,
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Constants.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          height: 60,
          child: Flex(
            direction: Axis.horizontal,
            children: [
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Icon(
                  Icons.elevator,
                  size: 30,
                  color: Constants.textHighlColor,
                ),
              ),
              const Text(
                "Elevator",
                style: TextStyle(
                    color: Constants.textHighlColor,
                    fontWeight: FontWeight.bold),
              ),
              const Flexible(
                  child: Center(
                      child: Text(
                "50 M",
                style: TextStyle(
                    color: Constants.textHighlColor,
                    fontWeight: FontWeight.bold),
              ))),
              Padding(
                padding: const EdgeInsets.all(8),
                child: cancelIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
