import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData theme = ThemeData(
    textTheme: TextTheme(headline2: TextStyle(color: Colors.deepPurple[700])),
    primarySwatch: Colors.blueGrey,
    inputDecorationTheme: const InputDecorationTheme(
        fillColor: Colors.white,
        labelStyle: TextStyle(
          color: Colors.blueGrey,
          fontSize: 14.0,
        )),
  );
}
