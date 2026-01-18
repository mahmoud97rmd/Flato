import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenRefreshGuard {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> refresh(String oldToken) async {
    try {
      // logic to refresh via REST
      final newToken = oldToken + "_refreshed"; 
      await _storage.write(key: "apiToken", value: newToken);
      return newToken;
    } catch (_) {
      return null;
    }
  }
}
