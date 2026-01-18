import 'package:http/http.dart' as http;

class TimeoutHandler {
  final Duration timeout;

  TimeoutHandler(this.timeout);

  Future<http.Response?> run(Future<http.Response> Function() fn) async {
    try {
      return await fn().timeout(timeout);
    } catch (_) {
      return null;
    }
  }
}
