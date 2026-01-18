import '../../../core/models/candle_entity.dart';

class LiquidityAnalyzer {
  final List<CandleEntity> candles;

  LiquidityAnalyzer(this.candles);

  double averageRange() {
    return candles.fold(0, (sum, c) => sum + (c.high - c.low)) / candles.length;
  }

  double volatility() {
    return averageRange(); // تبسيط
  }
}
