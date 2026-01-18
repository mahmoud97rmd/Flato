import 'package:flutter/animation.dart';

class ChartControllerManager {
  final List<AnimationController> _controllers = [];

  void register(AnimationController c) {
    _controllers.add(c);
  }

  void disposeAll() {
    for (final c in _controllers) {
      c.dispose();
    }
    _controllers.clear();
  }
}
