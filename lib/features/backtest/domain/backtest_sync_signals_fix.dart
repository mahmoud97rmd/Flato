void executeSignalsSafely() {
  updateEquity();
  for (final s in signals) {
    executeSignal(s);
  }
}
