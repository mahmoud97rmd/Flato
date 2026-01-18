import '../../engine/indicator_engine.dart';
import '../../../../core/models/candle_entity.dart';

class VWAPPlugin implements IndicatorPlugin {
  @override
  Map<String, double> compute(List<CandleEntity> candles) {
    double cumulPV = 0, cumulVol = 0;
    for (var c in candles) {
      final typical = (c.high + c.low + c.close) / 3;
      cumulPV += typical * c.volume;
      cumulVol += c.volume;
    }
    final vwap = cumulVol == 0 ? 0 : cumulPV / cumulVol;
    return {'VWAP': vwap};
  }
}
