import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin StreamControllerGuard on BlocBase {
  final List<StreamController> _controllers = [];

  StreamController<T> createController<T>({bool broadcast = false}) {
    final c = broadcast
        ? StreamController<T>.broadcast()
        : StreamController<T>();
    _controllers.add(c);
    return c;
  }

  @override
  Future<void> close() async {
    for (final c in _controllers) {
      await c.close();
    }
    _controllers.clear();
    return super.close();
  }
}
