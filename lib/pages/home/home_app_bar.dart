import 'package:flutter/material.dart';
import 'package:to_deer/services/size_helper.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
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
            onPressed: () {
              scaffoldKey!.currentState!.openEndDrawer();
            },
            icon: const Icon(
              Icons.menu_rounded,
              color: Colors.white,
            )),
      ],
      toolbarHeight: appBarHeight(context),
      backgroundColor: Colors.red,
      shadowColor: Colors.indigo,
      title: SizedBox(
        height: logoHeight(context),
        child: const Image(
          fit: BoxFit.fitWidth,
          color: Colors.white,
          image: AssetImage("images/icons/24.png"),
        ),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(50),
      )),
    );
  }
}
