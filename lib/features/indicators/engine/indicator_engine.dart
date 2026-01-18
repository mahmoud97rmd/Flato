import '../../../core/models/candle_entity.dart';

abstract class IndicatorPlugin {
  Map<String, double> compute(List<CandleEntity> candles);
}

class IndicatorEngine {
  final List<IndicatorPlugin> plugins;

  IndicatorEngine(this.plugins);

  Map<String, double> calculate(List<CandleEntity> candles) {
    final result = <String, double>{};
    for (final plugin in plugins) {
      result.addAll(plugin.compute(candles));
    }
    return result;
  }
}
