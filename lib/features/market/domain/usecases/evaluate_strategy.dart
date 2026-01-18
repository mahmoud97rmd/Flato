import '../strategy/strategy_config.dart';
import '../strategy/strategy_manager.dart';
import '../entities/candle.dart';

class EvaluateStrategy {
  TradeSignal call({
    required List<CandleEntity> candles,
    required StrategyConfig config,
  }) {
    final mgr = StrategyManager(candles, config);
    return mgr.evaluate();
  }
}
