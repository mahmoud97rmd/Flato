import 'dart:async';

class TimeframeStreamFix {
  StreamSubscription? _sub;

  void subscribe(Stream stream, Function onData) {
    _sub?.cancel(); // إلغاء القديم أولاً
    _sub = stream.listen((data) => onData(data));
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
