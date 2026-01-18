import '../../../core/models/candle_entity.dart';
import '../../../core/models/tick_entity.dart';

typedef TickListener = void Function(TickEntity tick);
typedef CandleListener = void Function(CandleEntity candle);

class MarketSyncCoordinator {
  final _tickListeners = <TickListener>[];
  final _candleListeners = <CandleListener>[];

  void registerTickListener(TickListener listener) => _tickListeners.add(listener);
  void registerCandleListener(CandleListener listener) => _candleListeners.add(listener);

  void dispatchTick(TickEntity tick) {
    for (final l in _tickListeners) {
      l(tick);
    }
  }

  void dispatchCandle(CandleEntity candle) {
    for (final l in _candleListeners) {
      l(candle);
    }
  }
}
