import 'dart:async';
import 'ws_reconnect_manager.dart';

class WsReconnectFix {
  final WsReconnectManager manager;
  Timer? _retry;

  WsReconnectFix(this.manager);

  void attempt(void Function(dynamic) onData) {
    _retry?.cancel();
    _retry = Timer.periodic(Duration(seconds: 5), (_) {
      manager.connect(onData);
    });
  }

  void stop() => _retry?.cancel();
}
