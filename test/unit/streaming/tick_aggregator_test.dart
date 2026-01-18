import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/data/streaming/tick_aggregator.dart';
import 'package:your_app/core/models/tick_entity.dart';

void main() {
  test('TickAggregator handles out of order ticks', () {
    final agg = TickAggregator("EUR_USD", Duration(seconds: 60));

    final t1 = TickEntity(instrument:"EUR_USD", timeUtc: DateTime.utc(2025,1,1,0,1), bid:2, ask:2);
    final t0 = TickEntity(instrument:"EUR_USD", timeUtc: DateTime.utc(2025,1,1,0,0), bid:1, ask:1);

    agg.addTick(t1);
    agg.addTick(t0);

    final candles = agg.buildCandles();
    expect(candles.length, 2);
    expect(candles[0].open, 1);
    expect(candles[1].open, 2);
  });
}
