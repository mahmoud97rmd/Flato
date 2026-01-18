import 'dart:async';
import 'package:flutter/foundation.dart';

class Dispatcher {
  static Future<T> computeAsync<T>(FutureOr<T> Function() fn) {
    return compute(_wrap, fn);
  }

  static T _wrap<T>(FutureOr<T> Function() fn) => fn();
}
