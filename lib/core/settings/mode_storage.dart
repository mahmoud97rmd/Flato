import 'package:shared_preferences/shared_preferences.dart';
import 'server_mode.dart';

class ModeStorage {
  static Future<void> save(ServerMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("server_mode", mode.name);
  }

  static Future<ServerMode> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString("server_mode") ?? "SANDBOX";
    return stored == "LIVE" ? ServerMode.live : ServerMode.sandbox;
  }
}
