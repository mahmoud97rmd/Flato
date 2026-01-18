import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData.light().copyWith(
    primaryColor: Colors.blue,
    brightness: Brightness.light,
  );

  static final dark = ThemeData.dark().copyWith(
    primaryColor: Colors.blueGrey,
    brightness: Brightness.dark,
  );
}
