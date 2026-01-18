import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'theme_hive.g.dart';

@HiveType(typeId: 10)
class ThemeEntity extends HiveObject {
  @HiveField(0)
  final bool isDark;

  @HiveField(1)
  final int primaryColorValue;

  @HiveField(2)
  final int accentColorValue;

  ThemeEntity({
    required this.isDark,
    required this.primaryColorValue,
    required this.accentColorValue,
  });

  ThemeData toThemeData() {
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: Color(primaryColorValue),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: MaterialColor(
          primaryColorValue,
          <int, Color>{
            50: Color(primaryColorValue),
            100: Color(primaryColorValue),
            200: Color(primaryColorValue),
            300: Color(primaryColorValue),
            400: Color(primaryColorValue),
            500: Color(primaryColorValue),
            600: Color(primaryColorValue),
            700: Color(primaryColorValue),
            800: Color(primaryColorValue),
            900: Color(primaryColorValue),
          },
        ),
      ).copyWith(secondary: Color(accentColorValue)),
    );
  }
}
