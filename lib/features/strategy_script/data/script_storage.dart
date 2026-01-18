import 'package:shared_preferences/shared_preferences.dart';

class ScriptStorage {
  static const _key = 'strategy_script';

  Future<void> save(String script) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, script);
  }

  Future<String?> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
