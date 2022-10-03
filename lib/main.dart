import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:mini_map/bloc/header/header_cubit.dart';
import 'package:mini_map/bloc/mark/mark_cubit.dart';
import 'package:mini_map/bloc/movement/movement_cubit.dart';
import 'package:mini_map/bloc/scan/scan_cubit.dart';
import 'package:mini_map/component/bottom_navinfo.dart';
import 'package:mini_map/constants.dart';
import 'package:mini_map/helper/fade_page_transition.dart';
import 'package:mini_map/page/search_page.dart';
import 'package:mini_map/repo/nav_repo.dart';
import 'package:mini_map/repo/pad_provider.dart';
import 'package:mini_map/repo/scan_repo.dart';
import 'component/custom_appbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  GetIt.I.registerSingleton<ScanRepository>(FirestoreScanRepository(),
      signalsReady: true);
  GetIt.I.registerSingleton<PadProvider>(FirestorePadProvider());
  GetIt.I.registerSingleton<NavRepository>(
      NavManagerRepository(
          GetIt.I.get<ScanRepository>(), GetIt.I.get<PadProvider>()),
      signalsReady: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Constants.primarySwatch),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: ((context) => HeaderCubit(GetIt.I.get<NavRepository>()))),
          BlocProvider(
              create: ((context) =>
                  MovementCubit(GetIt.I.get<NavRepository>()))),
          BlocProvider(
              create: ((context) => ScanCubit(GetIt.I.get<ScanRepository>()))),
          BlocProvider(
              create: ((context) => MarkCubit(GetIt.I.get<NavRepository>())))
        ],
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  void _navigateToSearch(BuildContext context) {
    //showSearch(context: context, delegate: DestinationSearchDelegate());
    Navigator.of(context).push(FadePageRoute(route: const SearchPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          textField: TextField(
            readOnly: true,
            style: const TextStyle(fontSize: 19),
            cursorColor: Colors.grey,
            onTap: (() {
              _navigateToSearch(context);
            }),
            decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: const Icon(Icons.menu),
                  color: Colors.black,
                  onPressed: () {
                    _navigateToSearch(context);
                  },
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  color: Colors.black,
                  onPressed: () {
                    _navigateToSearch(context);
                  },
                ),
                hintText: 'Search here',
                border: InputBorder.none),
            onChanged: (value) {},
          ),
        ),
        body: Stack(
          children: const [
            BottomNavInfo(),
            FloatingButtonLeyer(),
            //const MainView(),
          ],
        ));
  }
}

class MainView extends HookWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final scanning = useState(false);
    final searchController = useTextEditingController(text: 'XX-XX-XX-XX');

    final cubit = useBloc<ScanCubit>();

    useBlocListener(cubit, ((bloc, current, context) {
      searchController.text = (current as ScanState).tagCode;
      scanning.value = current is ScanningState;
    }));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const DirectionPointView(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 180,
            child: TextField(
              enabled: false,
              readOnly: true,
              textAlign: TextAlign.center,
              controller: searchController,
              decoration: const InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide:
                      BorderSide(color: Constants.primary800, width: 3.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide:
                      BorderSide(color: Constants.primary800, width: 3.0),
                ),
                hintText: 'XX-XX-XX-XX',
              ),
            ),
          ),
        ),
        Center(
          child: MaterialButton(
            height: 140,
            color: Constants.primary600,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(75.0), // Change your border radius here
              ),
            ),
            onPressed: () {
              cubit.toggleScanning();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  scanning.value
                      ? Icons.wifi_tethering
                      : Icons.wifi_tethering_off,
                  color:
                      scanning.value ? Constants.textHighlColor : Colors.white,
                  size: scanning.value ? 100 : 60,
                ),
                // Text(
                //   scanning.value ? "Scanning" : "Scan",
                //   style: TextStyle(
                //       color: scanning.value
                //           ? Constants.textHighlColor
                //           : Colors.white,
                //       fontSize: 20),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DirectionPointView extends HookWidget {
  const DirectionPointView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<MarkCubit>();
    useBlocBuilder(
      cubit,
      buildWhen: (current) => true,
    );
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: Constants.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            cubit.state.iconData,
            color: Colors.white,
            size: 80,
          ),
          Text(
            cubit.state.desc,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

class FloatingButtonLeyer extends HookWidget {
  const FloatingButtonLeyer({super.key});

  @override
  Widget build(BuildContext context) {
    final isSpeakerOn = useState(false);

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: 50,
          child: FloatingActionButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: Constants.primary,
            onPressed: (() {
              isSpeakerOn.value = !isSpeakerOn.value;
            }),
            tooltip: isSpeakerOn.value ? "Speaker ON" : "Speaker OFF",
            child: isSpeakerOn.value
                ? const Icon(
                    Icons.volume_up,
                    color: Constants.textHighlColor,
                    size: 22,
                  )
                : const Icon(
                    Icons.volume_off,
                    color: Colors.white54,
                    size: 22,
                  ),
          ),
        ),
      ),
    );
  }
}
