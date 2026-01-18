import 'dart:async';

class ReplaySchedulerFix {
  Timer? _timer;

  void start(void Function() cb, Duration interval) {
    stop();
    _timer = Timer.periodic(interval, (_) => cb());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
