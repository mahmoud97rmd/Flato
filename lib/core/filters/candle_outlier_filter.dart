import '../../core/models/candle_entity.dart';

class CandleOutlierFilter {
  final double maxAllowedRangePercentage;

  CandleOutlierFilter({this.maxAllowedRangePercentage = 50});

  /// Filters out candles whose range deviates too much compared to neighbors.
  bool isValid(CandleEntity candle) {
    if (candle.open == 0 || candle.high == 0 || candle.low == 0) {
      return false;
    }
    final range = candle.high - candle.low;
    final avgPrice = (candle.high + candle.low) / 2.0;
    final pct = (range / avgPrice) * 100.0;
    return pct <= maxAllowedRangePercentage;
  }
}
