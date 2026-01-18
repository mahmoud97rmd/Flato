import 'dart:async';

/// A simple sequential queue for async tasks.
/// Ensures tasks run one at a time in order.
class ExecutionQueue {
  final _taskController = StreamController<Future Function()>();

  ExecutionQueue() {
    _taskController.stream.asyncMap((task) => task()).listen((_) {});
  }

  /// Add a function that returns a Future to the queue.
  void schedule(Future Function() task) {
    _taskController.add(task);
  }

  /// Close the queue.
  Future<void> dispose() async {
    await _taskController.close();
  }
}
