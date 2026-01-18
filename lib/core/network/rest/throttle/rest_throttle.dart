import 'dart:async';

class RestThrottle {
  final Duration interval;
  DateTime _last = DateTime.fromMillisecondsSinceEpoch(0);

  RestThrottle(this.interval);

  bool canFetch() {
    if (DateTime.now().difference(_last) >= interval) {
      _last = DateTime.now();
      return true;
    }
    return false;
  }
}
