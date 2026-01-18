import 'dart:async';
import '../../../market/domain/entities/candle.dart';
import '../entities/speed.dart';

typedef OnCandleCallback = void Function(CandleEntity);

class ReplayEngine {
  final List<CandleEntity> candles;
  final OnCandleCallback onCandle;
  final ReplaySpeed speed;

  Timer? _timer;
  int _index = 0;

  ReplayEngine({
    required this.candles,
    required this.onCandle,
    this.speed = ReplaySpeed.x1,
  });

  void start() {
    stop();
    _index = 0;
    if (candles.isEmpty) return;

    final baseDelay = Duration(seconds: 1);
    final intervalMs = baseDelay.inMilliseconds ~/ speed.multiplier;

    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (_index >= candles.length) {
        stop();
        return;
      }
      onCandle(candles[_index]);
      _index++;
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void pause() => stop();

  bool get isRunning => _timer != null;
}
