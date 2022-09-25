import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mini_map/component/bottom_navinfo.dart';
import 'package:mini_map/constants.dart';
import 'package:mini_map/helper/fade_page_transition.dart';
import 'package:mini_map/page/search_page.dart';

import 'component/custom_appbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Constants.primarySwatch),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
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
          children: [
            const Center(
              child: Image(image: AssetImage('assets/images/coming_soon.jpg')),
            ),
            BottomNavInfo(),
            const FloatingButtonLeyer(),
          ],
        ));
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
