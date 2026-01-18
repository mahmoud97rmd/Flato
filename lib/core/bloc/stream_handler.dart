import 'dart:async';

class StreamHandler<T> {
  StreamSubscription? _sub;

  void listen(Stream<T> stream, void Function(T) onData) {
    _sub = stream.listen(onData);
  }

  Future<void> cancel() async {
    await _sub?.cancel();
  }
}
