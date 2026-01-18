import 'package:flutter/foundation.dart';

Duration tfToDuration(String tf) {
  switch (tf.toUpperCase()) {
    case "M1":
      return Duration(minutes: 1);
    case "M2":
      return Duration(minutes: 2);
    case "M3":
      return Duration(minutes: 3);
    case "M5":
      return Duration(minutes: 5);
    case "M15":
      return Duration(minutes: 15);
    case "H1":
      return Duration(hours: 1);
    default:
      return Duration(minutes: 1);
  }
}
