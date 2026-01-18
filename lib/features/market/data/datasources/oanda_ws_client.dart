import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class OandaWebSocketClient {
  final WebSocketChannel _channel;

  OandaWebSocketClient._(this._channel);

  factory OandaWebSocketClient({
    required String token,
    required String accountId,
    required String instrument,
  }) {
    final streamEndpoint = Uri(
      scheme: "wss",
      host: "stream-fxpractice.oanda.com",
      path: "/v3/pricing/stream",
      queryParameters: {
        "instruments": instrument,
      },
    );

    final ws = WebSocketChannel.connect(
      streamEndpoint,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return OandaWebSocketClient._(ws);
  }

  Stream<Map<String, dynamic>> get stream =>
      _channel.stream.map((event) => jsonDecode(event));

  void close() => _channel.sink.close();
}
