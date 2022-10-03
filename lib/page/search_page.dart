import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:mini_map/bloc/search/search_cubit.dart';
import 'package:mini_map/component/custom_appbar.dart';
import 'package:mini_map/constants.dart';
import 'package:mini_map/repo/nav_repo.dart';
import 'package:mini_map/repo/pad_provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => context.read<NavRepository>(),
      child: BlocProvider<SearchCubit>(
        create: (context) =>
            SearchCubit(FakePadProvider(), GetIt.I.get<NavRepository>()),
        child: const _SearchPage(),
      ),
    );
  }
}

class _SearchPage extends HookWidget {
  const _SearchPage();
  static List<String> category = ["Elevator", "Train", "Restroom", "Stairs"];

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController(text: '');
    final cubit = useBloc<SearchCubit>();
    final destinationList = useState(cubit.state);
    searchController.addListener(
      () {
        destinationList.value = cubit.state
            .where((e) => e.imagePath.contains(searchController.text))
            .toList();
      },
    );

    return Scaffold(
      appBar: CustomAppBar(
        textField: TextField(
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(fontSize: 19),
          controller: searchController,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                color: Colors.black,
                onPressed: () {
                  if (searchController.value.text.isEmpty) {
                    Navigator.pop(context);
                  } else {
                    searchController.clear();
                  }
                },
              ),
              hintText: 'Search here',
              border: InputBorder.none),
        ),
      ),
      body: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: category.length,
              itemBuilder: ((context, index) {
                return CategoryButton(
                  onPresed: () {
                    searchController.text = category[index];
                  },
                  text: category[index],
                );
              }),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: destinationList.value.length,
                separatorBuilder: ((context, index) => const Divider(
                      indent: 6,
                      endIndent: 6,
                      height: 6,
                      thickness: 2,
                    )),
                itemBuilder: (BuildContext context, int index) {
                  var destinaiton = destinationList.value[index];
                  return GestureDetector(
                    onTap: (() async {
                      _selectDestination(context, destinaiton.desc,
                          result: (value) {
                        if (value) {
                          cubit.selectDestination(destinaiton);
                          Navigator.of(context).pop(true);
                        }
                      });
                    }),
                    child: DestinationView(
                      image: destinaiton.imagePath,
                      desc: destinaiton.desc,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectDestination(BuildContext context, String desc,
      {required Function result}) {
    showDialog<bool>(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text("Please Confirm"),
            content: Text("Want navigation to [$desc] ?"),
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

class CategoryButton extends StatelessWidget {
  const CategoryButton({Key? key, required this.onPresed, required this.text})
      : super(key: key);

  final Function onPresed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: 80,
        child: TextButton.icon(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(
                            width: 2, color: Constants.primary)))),
            onPressed: (() => onPresed()),
            icon: Icon(Constants.destIcons[text] ?? Icons.train),
            label: Text(text)),
      ),
    );
  }
}

class DestinationView extends StatelessWidget {
  const DestinationView({super.key, required this.image, required this.desc});

  final String image;

  final String desc;

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
            icon: Icon(Constants.destIcons[image]),
            color: Colors.white,
            onPressed: () {},
          ),
          Flexible(
            child: Text(
              desc,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
