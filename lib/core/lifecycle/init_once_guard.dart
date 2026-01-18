class InitOnceGuard {
  bool _initialized = false;

  Future<void> runOnce(Future<void> Function() fn) async {
    if (_initialized) return;
    _initialized = true;
    await fn();
  }
}
