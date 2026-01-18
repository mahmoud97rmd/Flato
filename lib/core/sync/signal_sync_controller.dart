import 'dart:async';

/// Ensures that indicator values are updated before evaluating signals.
class SignalSyncController {
  final _queue = StreamController<Function()>();

  SignalSyncController() {
    _queue.stream.asyncMap((task) => Future(() => task())).listen((_) {});
  }

  void addTask(Function() task) {
    _queue.add(task);
  }

  Future<void> dispose() async {
    await _queue.close();
  }
}
