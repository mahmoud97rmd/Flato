import 'dart:async';

mixin StreamControllerManager {
  final List<StreamController> _controllers = [];

  StreamController<T> createController<T>({bool broadcast = false}) {
    final c = broadcast
        ? StreamController<T>.broadcast()
        : StreamController<T>();
    _controllers.add(c);
    return c;
  }

  Future<void> disposeControllers() async {
    for (final c in _controllers) {
      await c.close();
    }
    _controllers.clear();
  }
}
