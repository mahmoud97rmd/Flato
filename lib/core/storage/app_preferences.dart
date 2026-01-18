import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("dark_mode", isDark);
  }

  static Future<bool> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("dark_mode") ?? false;
  }
}
