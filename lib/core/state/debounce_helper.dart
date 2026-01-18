import 'dart:async';

class DebounceHelper<T> {
  final Duration delay;
  Timer? _timer;
  void Function(T)? _action;

  DebounceHelper(this.delay);

  void call(T value, void Function(T) action) {
    _action = action;
    _timer?.cancel();
    _timer = Timer(delay, () => action(value));
  }
}
