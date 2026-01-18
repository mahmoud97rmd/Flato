import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TimeframeStorage {
  static final _storage = FlutterSecureStorage();
  static const _key = "last_selected_timeframe";

  static Future<void> save(String tf) async {
    await _storage.write(key: _key, value: tf);
  }

  static Future<String> load() async {
    final v = await _storage.read(key: _key);
    return v ?? "M1";
  }
}
