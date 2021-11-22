import 'package:flutter/material.dart';

//Form

OutlineInputBorder authFormBorder() {
  return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)));
}

OutlineInputBorder taskFormBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.blueGrey),
  );
}

//Date

final List months = [
  'jan',
  'feb',
  'mar',
  'april',
  'may',
  'jun',
  'july',
  'aug',
  'sep',
  'oct',
  'November',
  'dec'
];
