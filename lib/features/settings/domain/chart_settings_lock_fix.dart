class ChartSettingsLockFix {
  bool _updating = false;

  Future<void> runSafe(Future<void> Function() fn) async {
    if (_updating) return;
    _updating = true;
    await fn();
    _updating = false;
  }
}
