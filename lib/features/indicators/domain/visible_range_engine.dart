import '../../../core/models/candle_entity.dart';

class VisibleRangeEngine {
  List<CandleEntity> applyVisibleRange(
    List<CandleEntity> candles,
    DateTime from,
    DateTime to,
  ) {
    return candles.where((c) => c.timeUtc.isAfter(from) && c.timeUtc.isBefore(to)).toList();
  }
}
