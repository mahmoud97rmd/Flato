import 'dart:async';

class ExecutionQueue {
  final _queue = StreamController<Function()>();

  ExecutionQueue() {
    _queue.stream.asyncMap((task) => Future(() => task())).listen((_) {});
  }

  void schedule(Function() exec) => _queue.add(exec);

  Future<void> dispose() => _queue.close();
}
