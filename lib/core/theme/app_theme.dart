import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData.from(
  colorScheme: ThemeData().colorScheme.copyWith(
        primary: const Color(0xffAC2216),
        primaryVariant: const Color(0xffCA6357),
        secondary: const Color(0xffffffff),
        secondaryVariant: const Color(0xffF7766A),
        background: const Color(0xffB9584F),
        surface: const Color(0xff781810),
        onPrimary: const Color(0xffffffff),
        onSecondary: const Color(0xffF73220),
        onBackground: const Color(0xffffffff),
        onSurface: const Color(0xffffffff),
      ),
).copyWith(
  textTheme: TextTheme(headline2: TextStyle(color: Colors.deepPurple[700])),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Color(0xffF7766A),
    labelStyle: TextStyle(
      color: Colors.white,
    ),
  ),
);
