import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UndoRedoStorage {
  static Future<void> save(String key, List<Map<String, dynamic>> states) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(states));
  }
  static Future<List<Map<String, dynamic>>?> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(key);
    if (str == null) return null;
    return (jsonDecode(str) as List).cast<Map<String, dynamic>>();
  }
}
