import 'dart:async';

class ReplayScheduler {
  Timer? _replayTimer;

  void start(void Function() onTick, Duration interval) {
    stop();
    _replayTimer = Timer.periodic(interval, (_) => onTick());
  }

  void stop() {
    _replayTimer?.cancel();
    _replayTimer = null;
  }
}
