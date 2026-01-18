import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/core/network/rest_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('REST client handles token expired (401)', () async {
    final mockClient = MockClient((request) async {
      return http.Response('', 401);
    });

    final client = RestClient("token","base", client: mockClient);
    expect(() => client.get("/x"), throwsException);
  });
}
