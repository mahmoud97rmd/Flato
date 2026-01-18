import '../../../../core/models/candle_entity.dart';

class GapAwareIndicator {
  static List<CandleEntity> fillGaps(
      List<CandleEntity> data, Duration interval) {
    if (data.isEmpty) return data;
    final List<CandleEntity> filled = [];
    for (int i = 0; i < data.length - 1; i++) {
      filled.add(data[i]);
      final diff = data[i + 1].timeUtc
          .difference(data[i].timeUtc)
          .inMilliseconds;
      if (diff > interval.inMilliseconds) {
        // Gap exists
        final count = (diff / interval.inMilliseconds).floor() - 1;
        for (int j = 1; j <= count; j++) {
          filled.add(CandleEntity(
            timeUtc: data[i].timeUtc
                .add(Duration(milliseconds: interval.inMilliseconds * j)),
            open: data[i].close,
            high: data[i].close,
            low: data[i].close,
            close: data[i].close,
            volume: 0,
          ));
        }
      }
    }
    filled.add(data.last);
    return filled;
  }
}
