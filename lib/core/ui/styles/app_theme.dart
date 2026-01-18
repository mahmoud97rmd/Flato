import 'package:flutter/material.dart';

final ThemeData kLightTheme = ThemeData(
  primarySwatch: Colors.indigo,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.indigo,
    titleTextStyle: TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
  ),
);

final ThemeData kDarkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.indigo,
);
