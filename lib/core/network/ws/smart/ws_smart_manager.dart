import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../network_observer.dart';

/// Smart WS Manager: handles connect/disconnect cleanly,
/// auto‑reconnect, disposals on app pause, and prevents leaks.
class WSSmartManager {
  WebSocketChannel? _channel;
  final String url;
  final NetworkObserver _observer;
  Timer? _reconnectTimer;

  bool _connected = false;

  WSSmartManager(this.url, this._observer) {
    _observer.stream.listen((state) {
      if (state == NetState.offline) {
        _disconnect();
      } else {
        _scheduleReconnect();
      }
    });
  }

  void connect(void Function(dynamic) onData) {
    _disconnect(); // always clean before new
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen(onData,
        onError: (_) => _scheduleReconnect(),
        onDone: () => _scheduleReconnect());
    _connected = true;
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (_connected) return;
      connect((_) {});
    });
  }

  void _disconnect() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    _connected = false;
  }

  void dispose() {
    _disconnect();
  }
}
