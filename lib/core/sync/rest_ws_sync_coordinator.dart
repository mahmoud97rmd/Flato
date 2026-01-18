import 'dart:async';

class RestWsSyncCoordinator {
  bool _historyLoaded = false;
  final List<Function()> _pendingConnectWs = [];

  void historyLoaded() {
    _historyLoaded = true;
    while (_pendingConnectWs.isNotEmpty) {
      final action = _pendingConnectWs.removeAt(0);
      action();
    }
  }

  void connectWsWhenReady(Function() connectFn) {
    if (_historyLoaded) {
      connectFn();
    } else {
      _pendingConnectWs.add(connectFn);
    }
  }
}
