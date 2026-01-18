import 'dart:async';

class ComputeGuard {
  bool _busy = false;

  Future<void> run(Future<void> Function() fn) async {
    while (_busy) {
      await Future.delayed(Duration(milliseconds: 5));
    }
    _busy = true;
    await fn();
    _busy = false;
  }
}
