import 'package:flutter/material.dart';

enum AppThemeMode { light, dark, system }

class AppTheme {
  final AppThemeMode mode;
  final Color bullCandle;
  final Color bearCandle;
  final Color emaColor;
  final Color rsiColor;
  final Color macdColor;
  final Color bollingerColor;

  const AppTheme({
    required this.mode,
    required this.bullCandle,
    required this.bearCandle,
    required this.emaColor,
    required this.rsiColor,
    required this.macdColor,
    required this.bollingerColor,
  });

  Map<String, dynamic> toJson() => {
        "mode": mode.name,
        "bullCandle": bullCandle.value,
        "bearCandle": bearCandle.value,
        "emaColor": emaColor.value,
        "rsiColor": rsiColor.value,
        "macdColor": macdColor.value,
        "bollingerColor": bollingerColor.value,
      };

  factory AppTheme.fromJson(Map<String, dynamic> json) {
    return AppTheme(
      mode: AppThemeMode.values.firstWhere(
        (e) => e.name == json["mode"],
        orElse: () => AppThemeMode.system,
      ),
      bullCandle: Color(json["bullCandle"]),
      bearCandle: Color(json["bearCandle"]),
      emaColor: Color(json["emaColor"]),
      rsiColor: Color(json["rsiColor"]),
      macdColor: Color(json["macdColor"]),
      bollingerColor: Color(json["bollingerColor"]),
    );
  }

  static AppTheme defaultLight() => AppTheme(
        mode: AppThemeMode.system,
        bullCandle: Colors.green,
        bearCandle: Colors.red,
        emaColor: Colors.blue,
        rsiColor: Colors.purple,
        macdColor: Colors.cyan,
        bollingerColor: Colors.teal,
      );
}
