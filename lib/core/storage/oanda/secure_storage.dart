import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OandaSecureStorage {
  final _storage = FlutterSecureStorage();

  static const _tokenKey = "oanda_token";
  static const _accountIdKey = "oanda_account";

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> loadToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> saveAccountId(String id) async {
    await _storage.write(key: _accountIdKey, value: id);
  }

  Future<String?> loadAccountId() async {
    return await _storage.read(key: _accountIdKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
