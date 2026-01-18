import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PersistentStateManager {
  static Future<void> save(String key, Map<String, dynamic> state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(state));
  }
  static Future<Map<String, dynamic>?> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(key);
    return str == null ? null : jsonDecode(str);
  }
}
