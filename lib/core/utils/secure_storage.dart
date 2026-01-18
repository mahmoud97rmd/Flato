import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Singleton
  static final _storage = FlutterSecureStorage();

  static const _keyApiToken = "secure_oanda_api_token";
  static const _keyAccountId = "secure_oanda_account_id";

  /// Save credentials securely
  static Future<void> saveCredentials({
    required String apiToken,
    required String accountId,
  }) async {
    await _storage.write(key: _keyApiToken, value: apiToken);
    await _storage.write(key: _keyAccountId, value: accountId);
  }

  /// Read secure keys
  static Future<Map<String, String>?> readCredentials() async {
    final token = await _storage.read(key: _keyApiToken);
    final accId = await _storage.read(key: _keyAccountId);

    if (token == null || accId == null) return null;

    return {
      "apiToken": token,
      "accountId": accId,
    };
  }

  /// Delete secure keys
  static Future<void> clearCredentials() async {
    await _storage.delete(key: _keyApiToken);
    await _storage.delete(key: _keyAccountId);
  }
}
