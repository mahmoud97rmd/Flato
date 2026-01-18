import '../../core/models/candle_entity.dart';

class ChartFilterFix {
  static List<CandleEntity> applyRange(
      List<CandleEntity> data, double minPrice, double maxPrice) {
    return data.where((c) =>
        c.high >= minPrice && c.low <= maxPrice).toList();
  }
}
