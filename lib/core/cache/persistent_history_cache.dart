import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PersistentHistoryCache {
  static const _keyPrefix = "history_cache_";

  static Future<void> save(String key, List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyPrefix + key, jsonEncode(data));
  }

  static Future<List<Map<String, dynamic>>?> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_keyPrefix + key);
    if (str == null) return null;
    return (jsonDecode(str) as List).cast<Map<String, dynamic>>();
  }

  static Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyPrefix + key);
  }
}
