import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AlertPreferences {
  static Future<void> save(String id, Map<String, dynamic> cfg) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("alert_$id", jsonEncode(cfg));
  }

  static Future<Map<String, dynamic>?> load(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString("alert_$id");
    return str == null ? null : jsonDecode(str);
  }
}
