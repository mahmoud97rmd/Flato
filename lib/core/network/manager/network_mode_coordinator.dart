import 'dart:async';
import '../network_observer.dart';

class NetworkModeCoordinator {
  bool _isOffline = false;
  final List<Function()> _onReconnectTasks = [];

  void updateState(NetState state) {
    if (state == NetState.offline) {
      _isOffline = true;
    } else {
      if (_isOffline) {
        _isOffline = false;
        _runReconnectTasks();
      }
    }
  }

  void scheduleOnReconnect(Function() task) {
    _onReconnectTasks.add(task);
  }

  void _runReconnectTasks() {
    for (final t in _onReconnectTasks) {
      t();
    }
    _onReconnectTasks.clear();
  }
}
