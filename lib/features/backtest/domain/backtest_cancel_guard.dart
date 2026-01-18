class BacktestCancelGuard {
  bool _cancel = false;

  void cancel() => _cancel = true;
  bool get cancelled => _cancel;
}
