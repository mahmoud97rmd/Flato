class TimeframeLoadingFix {
  bool _loading = false;

  Future<void> loadIfNotLoading(Future<void> Function() loadFn) async {
    if (_loading) return;
    _loading = true;
    await loadFn();
    _loading = false;
  }
}
