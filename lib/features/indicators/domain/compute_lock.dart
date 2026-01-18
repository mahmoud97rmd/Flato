import 'dart:async';

class ComputeLock {
  bool _busy = false;

  Future<T?> run<T>(Future<T> Function() fn) async {
    if (_busy) return null;
    _busy = true;
    final result = await fn();
    _busy = false;
    return result;
  }
}
