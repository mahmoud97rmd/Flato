import '../../../core/models/candle_entity.dart';
import 'indicator_engine.dart';

class ZoomSensitiveEngine extends IndicatorEngine {
  ZoomSensitiveEngine(super.plugins);

  Map<String, double> calculateInRange(
      List<CandleEntity> all, DateTime from, DateTime to) {
    final visible = all.where((c) => c.timeUtc.isAfter(from) && c.timeUtc.isBefore(to)).toList();
    return super.calculate(visible);
  }
}
