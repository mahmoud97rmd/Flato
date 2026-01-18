import '../../../market/domain/entities/candle.dart';

class CandleNormalizer {
  static List<CandleEntity> fillGaps(List<CandleEntity> input, Duration interval) {
    if (input.isEmpty) return [];
    List<CandleEntity> output = [];
    DateTime curr = input.first.time;

    final end = input.last.time;

    int idx = 0;
    while (curr.isBefore(end)) {
      if (idx < input.length && input[idx].time == curr) {
        output.add(input[idx]);
        idx++;
      } else {
        final prev = output.isNotEmpty ? output.last.close : 0;
        output.add(CandleEntity(
          time: curr,
          open: prev,
          high: prev,
          low: prev,
          close: prev,
          volume: 0,
        ));
      }
      curr = curr.add(interval);
    }
    return output;
  }
}
