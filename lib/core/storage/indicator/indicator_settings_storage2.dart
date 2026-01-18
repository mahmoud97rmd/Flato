import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class IndicatorSettingsStorage2 {
  static Future<void> save(String id, Map<String, dynamic> params) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "indicator_settings_$id";
    prefs.setString(key, jsonEncode(params));
  }

  static Future<Map<String, dynamic>?> load(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "indicator_settings_$id";
    final str = prefs.getString(key);
    return str == null ? null : jsonDecode(str);
  }
}
