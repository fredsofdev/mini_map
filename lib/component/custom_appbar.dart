import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mini_map/constants.dart';

class CustomAppBar extends HookWidget implements PreferredSizeWidget {
  const CustomAppBar({required this.textField, super.key});

  final Widget textField;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Constants.primary800,
                      blurRadius: 2,
                      spreadRadius: 1,
                      blurStyle: BlurStyle.outer,
                      offset: Offset(
                        0.0,
                        0.5,
                      ),
                    )
                  ]),
              child: Center(
                child: textField,
              ),
            ),
          ),
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(62.0);
}
