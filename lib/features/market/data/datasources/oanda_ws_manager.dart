import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class OandaWebSocketManager {
  final String token;
  final String accountId;
  final String instrument;

  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>> _controller =
      StreamController.broadcast();

  Timer? _heartbeat;

  OandaWebSocketManager({
    required this.token,
    required this.accountId,
    required this.instrument,
  });

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void connect() {
    final uri = Uri(
      scheme: "wss",
      host: "stream-fxpractice.oanda.com",
      path: "/v3/pricing/stream",
      queryParameters: {"instruments": instrument},
    );

    _channel = WebSocketChannel.connect(uri, headers: {
      "Authorization": "Bearer $token",
    });

    _channel?.stream.listen(
      (msg) {
        try {
          final json = msg is String ? jsonDecode(msg) : {};
          _controller.add(json);
        } catch (_) {}
      },
      onError: _onError,
      onDone: _onDone,
    );

    _startHeartbeat();
  }

  void _startHeartbeat() {
    _heartbeat?.cancel();
    _heartbeat = Timer.periodic(Duration(seconds: 15), (_) {
      _channel?.sink.add("ping");
    });
  }

  void _onError(error) {
    disconnect();
    Future.delayed(Duration(seconds: 5), connect);
  }

  void _onDone() {
    disconnect();
    Future.delayed(Duration(seconds: 5), connect);
  }

  void disconnect() {
    _heartbeat?.cancel();
    _channel?.sink.close();
    _channel = null;
  }
}

  Future<void> connectWithTimeframe(String tf) async {
    currentTimeframe = tf;
    disconnect();
    connect();
  }
