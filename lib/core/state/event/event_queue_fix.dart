import 'dart:async';

class EventQueueFix<T> {
  final _queue = StreamController<T>();
  bool _processing = false;

  void add(T evt) { _queue.add(evt); if (!_processing) _process(); }

  void _process() async {
    _processing = true;
    await for (final e in _queue.stream) {
      // معالجة الحدث داخل Bloc أو Handler
    }
    _processing = false;
  }

  void dispose() => _queue.close();
}
