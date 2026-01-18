import 'dart:async';

class IndicatorUpdateLock {
  bool _busy = false;

  Future<void> run(Future<void> Function() action) async {
    if (_busy) return;
    _busy = true;
    await action();
    _busy = false;
  }
}
