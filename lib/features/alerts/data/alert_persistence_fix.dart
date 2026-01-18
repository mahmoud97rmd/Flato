import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AlertPersistenceFix {
  static Future<void> save(String key, Map cfg) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("alert_cfg_$key", jsonEncode(cfg));
  }

  static Future<Map?> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString("alert_cfg_$key");
    return str == null ? null : jsonDecode(str);
  }
}
