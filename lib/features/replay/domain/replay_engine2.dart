import '../../../core/models/tick_entity.dart';
import '../../../core/models/candle_entity.dart';

typedef ReplayTickCb = void Function(TickEntity);
typedef ReplayCandleCb = void Function(CandleEntity);

class ReplayEngine2 {
  final List<TickEntity> ticks;
  final List<CandleEntity> candles;
  int _tickIdx = 0;
  int _candleIdx = 0;
  bool _playing = false;

  ReplayEngine2(this.ticks, this.candles);

  void play({required ReplayTickCb onTick, required ReplayCandleCb onCandle}) async {
    _playing = true;
    while (_playing &&
           (_tickIdx < ticks.length || _candleIdx < candles.length)) {
      if (_tickIdx < ticks.length) {
        onTick(ticks[_tickIdx++]);
      }
      if (_candleIdx < candles.length) {
        onCandle(candles[_candleIdx++]);
      }
      await Future.delayed(Duration(milliseconds: 200));
    }
  }

  void stop() => _playing = false;
}
