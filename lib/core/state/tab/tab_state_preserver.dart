import 'package:flutter/widgets.dart';

class TabStatePreserver with WidgetsBindingObserver {
  final Map<String, dynamic> _states = {};

  void save(String key, dynamic state) => _states[key] = state;
  dynamic restore(String key) => _states[key];
}
