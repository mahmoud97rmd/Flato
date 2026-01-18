class BacktestControlFix {
  bool _isRunning = false;

  bool startIfNotRunning(Function startFn) {
    if (_isRunning) return false;
    _isRunning = true;
    startFn();
    return true;
  }

  void done() => _isRunning = false;
}
