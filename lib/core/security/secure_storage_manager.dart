import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveOandaToken(String token) =>
      _storage.write(key: OandaConfig.tokenKey, value: token);

  static Future<String?> readOandaToken() =>
      _storage.read(key: OandaConfig.tokenKey);

  static Future<void> saveOandaAccount(String id) =>
      _storage.write(key: OandaConfig.accountKey, value: id);

  static Future<String?> readOandaAccount() =>
      _storage.read(key: OandaConfig.accountKey);
}
