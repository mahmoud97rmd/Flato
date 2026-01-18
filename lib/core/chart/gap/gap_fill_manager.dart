import '../../../../core/models/candle_entity.dart';

class GapFillManager {
  static List<CandleEntity> fill(
      List<CandleEntity> data, Duration interval) {
    final List<CandleEntity> filled = [];
    if (data.isEmpty) return filled;

    for (int i = 0; i < data.length - 1; i++) {
      final current = data[i];
      final next = data[i + 1];
      filled.add(current);

      final gap = next.timeUtc
          .difference(current.timeUtc)
          .inMilliseconds;
      final step = interval.inMilliseconds;

      if (gap > step) {
        final missing = (gap / step).floor() - 1;
        for (int j = 1; j <= missing; j++) {
          final t = current.timeUtc.add(Duration(milliseconds: step * j));
          filled.add(CandleEntity(
            timeUtc: t,
            open: current.close,
            high: current.close,
            low: current.close,
            close: current.close,
            volume: 0,
          ));
        }
      }
    }
    filled.add(data.last);
    return filled;
  }
}
