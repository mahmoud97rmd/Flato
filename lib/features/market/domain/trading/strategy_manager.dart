import '../entities/candle.dart';
import '../indicators/ema_calculator.dart';
import '../indicators/stochastic_calculator.dart';
import 'trade_position.dart';

class StrategyManager {
  final List<CandleEntity> candles;

  StrategyManager(this.candles);

  TradePosition? checkForSignal({
    required String instrument,
    required double currentPrice,
  }) {
    // EMA Cross Strategy
    final ema50 = EmaCalculator.calculate(data: candles, period: 50).values;
    final ema200 = EmaCalculator.calculate(data: candles, period: 200).values;

    final stoch = StochasticCalculator.calculate(
      data: candles,
      period: 14,
      smoothK: 3,
      smoothD: 3,
    );

    final int lastIndex = candles.length - 1;
    if (lastIndex < 200) return null;

    final crossBuy = (ema50[lastIndex] > ema200[lastIndex]) &&
        (stoch.kValues[lastIndex] > stoch.dValues[lastIndex]);

    final crossSell = (ema50[lastIndex] < ema200[lastIndex]) &&
        (stoch.kValues[lastIndex] < stoch.dValues[lastIndex]);

    if (crossBuy) {
      return TradePosition(
        instrument: instrument,
        type: TradeType.BUY,
        entryTime: candles[lastIndex].time,
        entryPrice: currentPrice,
        stopLoss: currentPrice * 0.998,
        takeProfit: currentPrice * 1.005,
      );
    }

    if (crossSell) {
      return TradePosition(
        instrument: instrument,
        type: TradeType.SELL,
        entryTime: candles[lastIndex].time,
        entryPrice: currentPrice,
        stopLoss: currentPrice * 1.002,
        takeProfit: currentPrice * 0.995,
      );
    }
    return null;
  }
}
