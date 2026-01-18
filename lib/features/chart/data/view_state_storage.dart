import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ViewStateStorage {
  static const key = "chart_view_state";

  static Future<void> save(Map<String, dynamic> state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(state));
  }

  static Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(key);
    return str == null ? null : jsonDecode(str);
  }
}
