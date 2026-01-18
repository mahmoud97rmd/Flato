class SignalEvalBufferFix {
  bool _processing = false;

  Future<void> process(Future<void> Function() fn) async {
    if (_processing) return;
    _processing = true;
    await fn();
    _processing = false;
  }
}
