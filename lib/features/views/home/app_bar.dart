import 'package:flutter/material.dart';
import 'package:to_deer/core/extension/context_extension.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  // ignore: use_key_in_widget_constructors
  const HomeAppBar({
    Key? key,
    this.scaffoldKey,
    required this.preferredSize,
  });
  final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  final Size preferredSize; // default is 56.0
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              scaffoldKey!.currentState!.openEndDrawer();
            },
            icon: const Icon(
              Icons.menu_rounded,
              color: Colors.white,
            )),
      ],
      toolbarHeight: context.appBarHeight,
      backgroundColor: const Color(0xffF31715),
      shadowColor: Colors.indigo,
      title: SizedBox(
        height: context.logoHeight,
        child: const Image(
          fit: BoxFit.fitWidth,
          color: Colors.white,
          image: AssetImage("images/icons/24.png"),
        ),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(40),
      )),
    );
  }
}
