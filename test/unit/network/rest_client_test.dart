import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

import 'package:my_app/core/network/rest/rest_client.dart';

void main() {
  test('REST GET success', () async {
    final mockClient = MockClient((request) async {
      return http.Response(jsonEncode({"result": "ok"}), 200);
    });

    final client = RestClient();
    final res = await client.get("/test", headers: {"x": "y"});
    expect(res["result"], "ok");
  });

  test('REST GET failure throws', () async {
    final mockClient = MockClient((request) async {
      return http.Response("Error", 500);
    });

    final client = RestClient();
    expect(() => client.get("/fail"), throwsA(isA<Exception>());
  });
}
