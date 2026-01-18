import 'dart:convert';
import 'package:http/http.dart' as http;

class SafeRestResponse {
  static Map<String, dynamic>? parse(http.Response res) {
    if (res.statusCode != 200) return null;
    try {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
