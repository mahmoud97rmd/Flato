import 'dart:async';
import 'dart:collection';

/// Buffer streaming data
class WsPipeline<T> {
  final int maxQueue;
  final Queue<T> _queue = Queue();
  StreamController<T>? _ctrl;

  WsPipeline({this.maxQueue = 10000}) {
    _ctrl = StreamController<T>.broadcast();
  }

  Stream<T>? get stream => _ctrl?.stream;

  void push(T e) {
    if (_queue.length > maxQueue) {
      _queue.removeFirst();
    }
    _queue.add(e);
    _drain();
  }

  void _drain() {
    while (_queue.isNotEmpty) {
      _ctrl?.add(_queue.removeFirst());
    }
  }

  void dispose() {
    _ctrl?.close();
  }
}
