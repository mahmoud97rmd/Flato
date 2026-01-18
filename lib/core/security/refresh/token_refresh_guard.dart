import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../oanda/oanda_config.dart';

class TokenRefreshGuard {
  final _storage = FlutterSecureStorage();

  Future<String?> refresh(String oldToken) async {
    try {
      final res = await http.post(
        Uri.parse("\${OandaConfig.restBaseUrl}/oauth2/token"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': oldToken,
        },
      );
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        final newToken = json['access_token'];
        await _storage.write(key: OandaConfig.tokenKey, value: newToken);
        return newToken;
      }
    } catch (_) {}
    return null;
  }
}
