import '../../../core/models/candle_entity.dart';
import 'indicator_engine.dart';

class ZoomSensitiveEngineFix extends IndicatorEngine {
  ZoomSensitiveEngineFix(super.plugins);

  Map<String, double> calculateInRange(
      List<CandleEntity> all, DateTime from, DateTime to) {
    final visible = all.where((c) =>
      !c.timeUtc.isBefore(from) && !c.timeUtc.isAfter(to)
    ).toList();
    final result = super.calculate(visible);
    return result;
  }
}
