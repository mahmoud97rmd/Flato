import 'dart:async';

class WsBackoffManager {
  int _attempts = 0;
  Timer? _timer;

  void scheduleReconnect(Function() reconnect) {
    _timer?.cancel();
    _attempts++;
    final wait = Duration(seconds: 2 * _attempts);
    _timer = Timer(wait, reconnect);
  }

  void reset() => _attempts = 0;
}
