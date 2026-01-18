import 'dart:async';

class AsyncDisposeGuard {
  bool _disposing = false;
  final List<Future<void>> _pending = [];

  void track(Future<void> future) {
    if (!_disposing) _pending.add(future);
  }

  Future<void> dispose() async {
    _disposing = true;
    await Future.wait(_pending);
    _pending.clear();
  }
}
