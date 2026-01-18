import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WsReconnectManager {
  final String url;
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;

  WsReconnectManager(this.url);

  void connect(void Function(dynamic) onData) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel?.stream.listen(onData,
        onError: (_) => _scheduleReconnect(onData),
        onDone: () => _scheduleReconnect(onData));
  }

  void _scheduleReconnect(void Function(dynamic) onData) {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: 5), () => connect(onData));
  }

  void dispose() {
    _channel?.sink.close();
    _reconnectTimer?.cancel();
  }
}
