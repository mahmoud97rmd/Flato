import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChartSettingsStorage {
  static const key = "chart_settings";

  static Future<void> save(Map<String, dynamic> cfg) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(cfg));
  }

  static Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(key);
    return str == null ? null : jsonDecode(str);
  }
}
