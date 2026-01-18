import 'dart:async';
import 'ws_reconnect_manager.dart';

class WsReconnectGuardFix {
  final WsReconnectManager manager;
  bool _attempting = false;

  WsReconnectGuardFix(this.manager);

  void attemptReconnect(void Function(dynamic) onData) {
    if (_attempting) return;
    _attempting = true;
    manager.connect((msg) {
      onData(msg);
      _attempting = false;
    });
  }
}
