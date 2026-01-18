import 'dart:async';

class IndicatorQueueFix {
  final _queue = StreamController<void>();

  void enqueue(void Function() task) {
    _queue.add(null);
    task();
  }

  void dispose() {
    _queue.close();
  }
}
