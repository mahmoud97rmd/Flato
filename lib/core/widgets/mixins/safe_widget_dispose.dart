import 'dart:async';
import 'package:flutter/widgets.dart';

mixin SafeWidgetDispose<T extends StatefulWidget> on State<T> {
  final List<StreamSubscription> _subs = [];
  final List<AnimationController> _controllers = [];

  void trackSub(StreamSubscription sub) => _subs.add(sub);

  void trackController(AnimationController controller) =>
      _controllers.add(controller);

  @override
  void dispose() {
    for (final sub in _subs) sub.cancel();
    _subs.clear();
    for (final controller in _controllers) controller.dispose();
    _controllers.clear();
    super.dispose();
  }
}
