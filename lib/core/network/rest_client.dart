import 'dart:convert';
import 'package:http/http.dart' as http;

class RestClient {
  final String token;
  final String baseUrl;

  RestClient(this.token, this.baseUrl);

  Future<http.Response> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    for (int attempt = 0; attempt < 3; attempt++) {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 429) {
        final retryAfter = response.headers['retry-after'];
        final wait = int.tryParse(retryAfter ?? '2') ?? 2;
        await Future.delayed(Duration(seconds: wait));
      } else if (response.statusCode == 401) {
        // Handle token refresh logic here
        throw Exception('Token expired');
      } else {
        return response;
      }
    }

    throw Exception('Too many requests, even after retrying.');
  }
}
