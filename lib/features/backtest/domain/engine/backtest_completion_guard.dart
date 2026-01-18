class BacktestCompletionGuard {
  bool _done = false;

  void markDone() => _done = true;
  bool get isDone => _done;

  void reset() => _done = false;
}
