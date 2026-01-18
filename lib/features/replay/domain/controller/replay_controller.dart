import 'dart:async';

class ReplayController {
  final List<StreamSubscription> _subs = [];
  bool _isPlaying = false;

  void play(Stream stream, void Function(dynamic) onData) {
    stop();      // توقف أي تشغيل سابق
    _isPlaying = true;
    final sub = stream.listen((data) {
      if (!_isPlaying) return;
      onData(data);
    });
    _subs.add(sub);
  }

  void stop() {
    _isPlaying = false;
    for (final s in _subs) {
      s.cancel();
    }
    _subs.clear();
  }

  void dispose() => stop();
}
