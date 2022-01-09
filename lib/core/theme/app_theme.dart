import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData.from(
  colorScheme: ThemeData().colorScheme.copyWith(
      // primary: const Color(0xffffffff),
      // primaryVariant: const Color(0xff0F608E),
      // secondary: const Color(0xff1D91D2),
      // onPrimary: const Color(0xff0F608E),
      // onSecondary: const Color(0xffffffff),
      // brightness: Brightness.light,
      // onBackground: const Color(0xffffffff),
      ),
).copyWith(
  textTheme: TextTheme(headline2: TextStyle(color: Colors.deepPurple[700])),
  // primarySwatch: Colors.blueGrey,
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Colors.white,
    labelStyle: TextStyle(
      color: Colors.blueGrey,
      fontSize: 14.0,
    ),
  ),
);
