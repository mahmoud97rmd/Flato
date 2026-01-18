import 'dart:async';

class SettingsDebouncer {
  final Duration delay;
  Timer? _timer;

  SettingsDebouncer({this.delay = const Duration(milliseconds: 300)});

  void save(void Function() saveFn) {
    _timer?.cancel();
    _timer = Timer(delay, saveFn);
  }
}
