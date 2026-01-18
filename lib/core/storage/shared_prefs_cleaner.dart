import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsCleaner {
  static Future<void> cleanAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
