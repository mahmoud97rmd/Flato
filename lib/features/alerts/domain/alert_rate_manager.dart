class AlertRateManager {
  DateTime? _lastTime;

  bool canNotify(Duration gap) {
    final now = DateTime.now();
    if (_lastTime == null || now.difference(_lastTime!) >= gap) {
      _lastTime = now;
      return true;
    }
    return false;
  }

  void reset() => _lastTime = null;
}
