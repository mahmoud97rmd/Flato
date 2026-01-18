import 'package:flutter/foundation.dart';
import '../../../features/market/domain/entities/candle.dart';

class GapFillManager {
  static List<Candle> fillGaps(
      List<Candle> history, Candle lastLive, Duration timeframe) {
    final List<Candle> result = List.from(history);

    DateTime expectedNext =
        history.isEmpty ? lastLive.time : history.last.time.add(timeframe);

    while (expectedNext.isBefore(lastLive.time)) {
      // انسخ آخر شمعة متوقعة واملأها بنفس السعر
      final c = Candle(
        time: expectedNext,
        open: history.last.close,
        high: history.last.close,
        low: history.last.close,
        close: history.last.close,
      );
      result.add(c);
      expectedNext =
          expectedNext.add(timeframe); // التاريخ التالي المتوقع
    }

    result.add(lastLive);
    return result;
  }
}
