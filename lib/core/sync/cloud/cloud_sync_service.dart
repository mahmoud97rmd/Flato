import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// يمكن استبدال بـ Firebase/Backend حقيقي لاحقًا

class CloudSyncService {
  static Future<void> uploadUserSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("cloud_user_settings", jsonEncode(settings));
  }

  static Future<Map<String, dynamic>?> downloadUserSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString("cloud_user_settings");
    return str == null ? null : jsonDecode(str);
  }
}
