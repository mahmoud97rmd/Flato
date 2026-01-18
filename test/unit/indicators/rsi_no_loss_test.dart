import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/strategy/domain/indicators/rsi_indicator.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  test('RSI when there is no loss should be 100', () {
    final rsi = RSIIndicator(14);
    final candles = List.generate(20, (i) => CandleEntity(
      instrument: "EUR_USD",
      timeUtc: DateTime.utc(2025,1,1,0,i),
      open: i.toDouble(),
      high: i.toDouble()+1,
      low: i.toDouble(),
      close: i.toDouble()+2,
      volume: 1,
    ));

    for (var c in candles) {
      rsi.addCandle(c);
    }

    expect(rsi.current, 100.0);
  });
}
