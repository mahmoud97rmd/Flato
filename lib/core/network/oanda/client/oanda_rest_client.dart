import 'dart:convert';
import 'package:http/http.dart' as http;
import '../oanda_config.dart';
import '../../../core/security/secure_storage_manager.dart';

class OandaRestClient {
  Future<http.Response> _call(String url) async {
    final token = await SecureStorageManager.readOandaToken();
    final headers = {
      "Authorization": "Bearer \$token",
      "Content-Type": "application/json",
    };
    return http.get(Uri.parse(url), headers: headers);
  }

  Future<List<String>> fetchInstruments() async {
    final accountId = await SecureStorageManager.readOandaAccount();
    final url =
        "\${OandaConfig.restBaseUrl}/accounts/\$accountId/instruments";
    final res = await _call(url);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final list = json["instruments"] as List;
      return list.map((i) => i["name"].toString()).toList();
    }
    throw Exception("OANDA fetchInstruments failed: \${res.body}");
  }

  Future<List<Map<String, dynamic>>> fetchCandles(
      String symbol, String granularity) async {
    final accountId = await SecureStorageManager.readOandaAccount();
    final url =
        "\${OandaConfig.restBaseUrl}/instruments/\$symbol/candles?granularity=\$granularity&count=500";
    final res = await _call(url);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final candles = json["candles"] as List;
      return candles.map((c) => c as Map<String, dynamic>).toList();
    }
    throw Exception("OANDA fetchCandles failed: \${res.body}");
  }
}
