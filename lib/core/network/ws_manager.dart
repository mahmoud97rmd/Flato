import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WSManager {
  final String url;
  WebSocketChannel? _channel;
  StreamController<String> _streamController = StreamController.broadcast();
  Timer? _reconnectTimer;
  Timer? _pingTimer;

  WSManager(this.url);

  Stream<String> get stream => _streamController.stream;

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel!.stream.listen(
      (event) {
        _streamController.add(event);
      },
      onDone: _handleDisconnect,
      onError: (err) {
        print('WebSocket error: $err');
        _handleDisconnect();
      },
      cancelOnError: true,
    );

    _startPing();
  }

  void _handleDisconnect() {
    _stopPing();
    _reconnectTimer = Timer(Duration(seconds: 3), () {
      connect();
    });
  }

  void _startPing() {
    _pingTimer = Timer.periodic(Duration(seconds: 15), (_) {
      _channel?.sink.add('ping');
    });
  }

  void _stopPing() {
    _pingTimer?.cancel();
  }

  void send(String msg) {
    _channel?.sink.add(msg);
  }

  void dispose() {
    _stopPing();
    _reconnectTimer?.cancel();
    _channel?.sink.close(status.goingAway);
  }
}
