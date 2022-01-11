import 'package:flutter/material.dart';
import 'package:to_deer/core/extension/context_extension.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
    this.scaffoldKey,
    required this.preferredSize,
  }) : super(key: key);
  final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  final Size preferredSize; // default is 56.0
  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: context.colors.primary,
      elevation: 0,
      actions: [
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => scaffoldKey!.currentState!.openEndDrawer(),
          icon: const Icon(
            Icons.menu_rounded,
          ),
        ),
      ],
      backgroundColor: context.colors.secondary,
    );
  }
}
