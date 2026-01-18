import '../../engine/indicator_engine.dart';
import '../../../../core/models/candle_entity.dart';

class EMAPlugin implements IndicatorPlugin {
  final int period;
  double? prevEma;

  EMAPlugin(this.period);

  @override
  Map<String, double> compute(List<CandleEntity> candles) {
    final prices = candles.map((e) => e.close).toList();
    final multiplier = 2 / (period + 1);
    double? ema = prevEma ?? prices.first;

    for (final price in prices) {
      ema = (price - ema!) * multiplier + ema;
    }

    prevEma = ema;
    return {'EMA$period': ema ?? 0};
  }
}
