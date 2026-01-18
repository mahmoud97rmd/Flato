import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryCacheGuard {
  static Future<void> save(
      String symbol, String timeframe, List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "$symbol-$timeframe";
    prefs.setString(key, jsonEncode(data));
  }

  static Future<List<Map<String, dynamic>>?> load(
      String symbol, String timeframe) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "$symbol-$timeframe";
    final str = prefs.getString(key);
    if (str == null) return null;
    return (jsonDecode(str) as List).cast<Map<String, dynamic>>();
  }
}
