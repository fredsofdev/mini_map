import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:mini_map/bloc/header/header_cubit.dart';
import 'package:mini_map/bloc/movement/movement_cubit.dart';
import 'package:mini_map/constants.dart';
import 'package:mini_map/main.dart';
import 'package:we_slide/we_slide.dart';

class BottomNavInfo extends HookWidget {
  const BottomNavInfo({super.key});

  final double panelMin = 70;
  final double panelMax = 500;

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
    final cubit = useBloc<HeaderCubit>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: WeSlide(
        backgroundColor: Colors.transparent,
        controller: val.value,
        panelMinSize: panelMin,
        panelMaxSize: panelMax,
        hidePanelHeader: false,
        //bodyWidth: 0,
        body: const MainView(),
        panel: MovementPanel(panelMin: panelMin),
        panelHeader: HookBuilder(builder: (context) {
          useBlocBuilder(cubit, buildWhen: ((current) => true));

          return NavInfoHeader(
            key: UniqueKey(),
            isVisable: cubit.state is NavigatingState,
            onTap: () {
              val.value.show();
            },
            cancelIcon: IconButton(
              iconSize: 40,
              icon: isOpen.value
                  ? const Icon(Icons.arrow_circle_down)
                  : const Icon(Icons.highlight_off),
              color: Colors.white,
              onPressed: () {
                if (isOpen.value) {
                  val.value.hide();
                } else {
                  _cancel(context, result: (value) {
                    if (value) cubit.cancelNavigation();
                  });
                }
              },
            ),
            iconData: cubit.state.iconData,
            destination: cubit.state.destination,
            leftMeters: cubit.state.leftMeters,
          );
        }),
      ),
    );
  }

  void _cancel(BuildContext context, {required Function result}) {
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
        }).then((value) => result(value));
  }
}

class MovementPanel extends HookWidget {
  const MovementPanel({
    Key? key,
    required this.panelMin,
  }) : super(key: key);

  final double panelMin;

  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<MovementCubit>();
    useBlocBuilder(cubit);

    return Padding(
      padding: EdgeInsets.fromLTRB(0, panelMin, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Constants.primary600,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: cubit.state.movements.length,
          itemBuilder: (BuildContext context, int index) {
            return cubit.state.movements[index];
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            indent: 6,
            endIndent: 6,
            height: 6,
            thickness: 2,
          ),
        ),
      ),
    );
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
      required this.iconData,
      required this.destination,
      required this.leftMeters,
      super.key});

  final bool isVisable;
  final Function onTap;
  final IconButton cancelIcon;
  final IconData iconData;
  final String destination;
  final String leftMeters;
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
          height: 71,
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Icon(
                  iconData,
                  size: 30,
                  color: Constants.textHighlColor,
                ),
              ),
              Text(
                destination,
                style: const TextStyle(
                    color: Constants.textHighlColor,
                    fontWeight: FontWeight.bold),
              ),
              Flexible(
                  child: Center(
                      child: Text(
                leftMeters,
                style: const TextStyle(
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
