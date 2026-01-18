import 'dart:convert';
import 'package:http/http.dart' as http;
import '../retry/retry_policy.dart';
import '../security/http_pinning_client.dart';
import '../../logging/audit_logger.dart';

class RestClient {
  final RetryPolicy _retry = RetryPolicy();

  Future<String> _baseUrl() =>
      ModeStorage.load().then((mode) => mode == ServerMode.live
          ? "https://api-fxtrade.oanda.com/v3"
          : "https://api-fxpractice.oanda.com/v3");

  Future<dynamic> get(String path,
      {Map<String, String>? headers}) async {
    final url = "\${await _baseUrl()}\$path";
    http.Client client = await HttpPinningClient.create();

    return _retry.execute(() => client.get(Uri.parse(url), headers: headers)
        .then((res) {
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw Exception(
            "REST GET \${res.statusCode}: \${res.body}");
      }
      return jsonDecode(res.body);
    }), onRetry: (attempt, delay, type) {
      AuditLogger.log("REST_RETRY", {
        "url": url,
        "attempt": attempt,
        "delay": delay.inString(),
        "type": type.toString(),
      });
    });
  }

  Future<dynamic> post(String path,
      {Map<String, String>? headers, Object? body}) async {
    final url = "\${await _baseUrl()}\$path";
    http.Client client = await HttpPinningClient.create();

    return _retry.execute(() => client
        .post(Uri.parse(url),
            headers: headers, body: jsonEncode(body))
        .then((res) {
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw Exception(
            "REST POST \${res.statusCode}: \${res.body}");
      }
      return jsonDecode(res.body);
    }), onRetry: (attempt, delay, type) {
      AuditLogger.log("REST_RETRY", {
        "url": url,
        "attempt": attempt,
        "delay": delay.inString(),
        "type": type.toString(),
      });
    });
  }
}
