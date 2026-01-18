import 'dart:async';

class PreferencesWriteLock {
  Completer<void>? _lock;

  Future<void> synchronized(Future<void> Function() fn) async {
    while (_lock != null) {
      await _lock!.future;
    }
    _lock = Completer<void>();
    await fn();
    _lock!.complete();
    _lock = null;
  }
}
