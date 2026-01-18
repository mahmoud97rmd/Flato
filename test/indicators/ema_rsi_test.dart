import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/strategy/domain/indicators/ema_indicator.dart';
import 'package:your_app/features/strategy/domain/indicators/rsi_indicator.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  final candles = List.generate(20, (i) => CandleEntity(
    instrument: "XAU_USD",
    timeUtc: DateTime.utc(2025,1,1,0,i),
    open: i.toDouble(),
    high: i.toDouble(),
    low: i.toDouble(),
    close: i.toDouble(),
    volume: 1,
  ));

  test('EMA calculates correctly', () {
    final ema = EMAIndicator(10);
    for (final c in candles) ema.addCandle(c);
    expect(ema.series.length, candles.length);
    expect(ema.current, greaterThan(0));
  });

  test('RSI calculates correctly', () {
    final rsi = RSIIndicator(14);
    for (final c in candles) rsi.addCandle(c);
    expect(rsi.series.length, greaterThan(1));
    expect(rsi.current, inInclusiveRange(0, 100));
  });
}
