import '../../../market/domain/entities/candle.dart';
import '../../../market/domain/entities/tick.dart';

class CandleAggregator {
  final Duration interval;
  final List<CandleEntity> result = [];
  DateTime? currentStart;
  CandleEntity? current;

  List<Tick> buffer = [];

  CandleAggregator(this.interval);

  void processTick(Tick tick) {
    buffer.add(tick);
    buffer.sort((a, b) => a.time.compareTo(b.time));

    final start = _alignToInterval(buffer.first.time);

    if (currentStart == null) {
      currentStart = start;
      current = CandleEntity(
        time: start,
        open: buffer.first.price,
        high: buffer.first.price,
        low: buffer.first.price,
        close: buffer.first.price,
        volume: 0,
      );
    }

    while (buffer.isNotEmpty) {
      final t = buffer.removeAt(0);

      if (t.time.isBefore(currentStart!.add(interval))) {
        current!.high = max(current!.high, t.price);
        current!.low = min(current!.low, t.price);
        current!.close = t.price;
        current!.volume += 1;
      } else {
        result.add(current!);
        currentStart = _alignToInterval(t.time);
        current = CandleEntity(
          time: currentStart!,
          open: t.price,
          high: t.price,
          low: t.price,
          close: t.price,
          volume: 1,
        );
      }
    }
  }

  DateTime _alignToInterval(DateTime t) {
    final millis = t.millisecondsSinceEpoch;
    final intInterval = interval.inMilliseconds;
    final startMillis = (millis ~/ intInterval) * intInterval;
    return DateTime.fromMillisecondsSinceEpoch(startMillis);
  }
}
