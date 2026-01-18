import 'dart:async';

class SymbolStreamGuard {
  StreamSubscription? _sub;

  void bind(Stream stream, void Function(dynamic) onData) {
    _sub?.cancel(); // إلغاء الاشتراك السابق دائمًا
    _sub = stream.listen(onData);
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
