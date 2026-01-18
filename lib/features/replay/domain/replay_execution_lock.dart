class ReplayExecutionLock {
  bool _busy = false;

  Future<void> runSafe(Future<void> Function() fn) async {
    if (_busy) return;
    _busy = true;
    await fn();
    _busy = false;
  }
}
