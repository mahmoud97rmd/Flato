import '../../../../core/models/candle_entity.dart';

class ChartDataStitcher {
  List<CandleEntity> merge(
      List<CandleEntity> history, List<CandleEntity> live) {
    final Map<int, CandleEntity> map = {};
    for (final c in history) {
      map[c.timeUtc.millisecondsSinceEpoch] = c;
    }
    for (final c in live) {
      map[c.timeUtc.millisecondsSinceEpoch] = c;
    }
    final keys = map.keys.toList()..sort();
    return keys.map((k) => map[k]!).toList();
  }
}
