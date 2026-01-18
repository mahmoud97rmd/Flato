import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class IndicatorSettingsStorageSP {
  static const _key = "indicatorSettings";

  static Future<void> save(String id, Map<String, dynamic> params) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key + id, jsonEncode(params));
  }

  static Future<Map<String, dynamic>?> load(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_key + id);
    return str == null ? null : jsonDecode(str);
  }
}
