import 'package:flutter/material.dart';

Size displaySize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double displayWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double appBarHeight(BuildContext context) {
  return displayHeight(context) / 10;
}

double bottomBar(BuildContext context) {
  return displayHeight(context) / 11;
}

double taskFormWidth(BuildContext context) {
  return displayWidth(context) / 1.25;
}
