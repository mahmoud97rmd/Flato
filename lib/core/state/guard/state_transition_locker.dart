class StateTransitionLocker {
  bool _processing = false;

  Future<void> safeTransition(Future<void> Function() fn) async {
    if (_processing) return;
    _processing = true;
    await fn();
    _processing = false;
  }
}
