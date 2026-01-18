import '../../../core/models/candle_entity.dart';

class CandleDeduper {
  final Set<int> _seenTimestamps = {};

  bool isDuplicate(CandleEntity candle) {
    final ts = candle.timeUtc.millisecondsSinceEpoch;
    if (_seenTimestamps.contains(ts)) return true;
    _seenTimestamps.add(ts);
    return false;
  }
}
