import 'dart:async';

class EventQueue<T> {
  final _queue = StreamController<T>();
  bool _processing = false;

  void add(T event) {
    _queue.add(event);
    if (!_processing) _process();
  }

  void _process() async {
    _processing = true;
    await for (final e in _queue.stream) {
      // يمرّر هذا الحدث إلى الـ Bloc أو Handler المناسب
    }
    _processing = false;
  }

  void dispose() => _queue.close();
}
