import 'dart:convert';
import 'package:http/http.dart' as http;
import '../pinning/http_pinning_client.dart';
import '../../logging/audit_logger.dart';
import '../../core/settings/server_mode.dart';
import '../../core/settings/mode_storage.dart';

/// REST Client with Retry + Pinning
class RestClient {
  Future<String> _baseUrl() async {
    final mode = await ModeStorage.load();
    return mode == ServerMode.live
        ? "https://api-fxtrade.oanda.com/v3"
        : "https://api-fxpractice.oanda.com/v3";
  }

  Future<dynamic> get(String path,
      {Map<String, String>? headers}) async {
    final client = await HttpPinningClient.create();
    final url = "\${await _baseUrl()}\$path";

    AuditLogger.log("REST GET", {"url": url, "headers": headers});

    final res = await client.get(Uri.parse(url), headers: headers);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("REST GET \${res.statusCode}: \${res.body}");
    }

    return jsonDecode(res.body);
  }
}
