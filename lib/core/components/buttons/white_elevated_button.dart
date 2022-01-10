import 'package:flutter/material.dart';
import 'package:to_deer/core/extension/context_extension.dart';

class WhiteElevatedButton extends StatelessWidget {
  const WhiteElevatedButton(
      {Key? key, required this.onPressed, required this.child})
      : super(key: key);
  final VoidCallback onPressed;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(context.colors.secondary),
        foregroundColor: MaterialStateProperty.all(
          context.colors.primary,
        ),
      ),
    );
  }
}
