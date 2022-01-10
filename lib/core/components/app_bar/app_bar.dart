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
      elevation: 0,
      actions: [
        IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              scaffoldKey!.currentState!.openEndDrawer();
            },
            icon: Icon(
              Icons.menu_rounded,
              color: context.colors.secondaryVariant,
            )),
      ],
      toolbarHeight: context.appBarHeight,
      backgroundColor: context.colors.secondary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(40),
      )),
    );
  }
}
