import '../../../core/models/candle_entity.dart';
import 'indicator_engine.dart';

class WindowedIndicatorEngine extends IndicatorEngine {
  WindowedIndicatorEngine(super.plugins);

  @override
  Map<String, double> calculate(List<CandleEntity> candles) {
    final windowSize = 500; // آخر 500 شمعة فقط
    final subset = candles.length > windowSize
        ? candles.sublist(candles.length - windowSize)
        : candles;
    return super.calculate(subset);
  }
}
