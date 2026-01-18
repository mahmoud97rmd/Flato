class BacktestCancelGuard2 {
  bool _cancelled = false;

  void cancel() => _cancelled = true;
  bool get isCancelled => _cancelled;
}
