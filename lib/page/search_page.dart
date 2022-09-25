import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mini_map/component/custom_appbar.dart';
import 'package:mini_map/constants.dart';

class SearchPage extends HookWidget {
  const SearchPage({super.key});

  static List<String> category = ["Elevator", "Train", "Restroom", "Stairs"];

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController(text: '');
    final destinationList = useState(Constants.fakeDestiontions);

    useEffect((() {
      searchController.addListener(() {
        destinationList.value = Constants.fakeDestiontions
            .where((e) => e.imagePath.contains(searchController.text))
            .toList();
      });
      return null;
    }), []);

    return Scaffold(
      appBar: CustomAppBar(
        textField: TextField(
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
                    onTap: (() {
                      _selectDestination(context, destinaiton.desc);
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

  void _selectDestination(BuildContext context, String desc) {
    showDialog(
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
        }).then((value) => print(value));
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
