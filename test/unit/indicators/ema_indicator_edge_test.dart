import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/strategy/domain/indicators/ema_indicator.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  test('EMA with constant values stabilizes', () {
    final ema = EMAIndicator(5);
    final candles = List.generate(100, (i) => CandleEntity(
      instrument: "XAU_USD",
      timeUtc: DateTime.utc(2025,1,1,0,i),
      open: 10.0,
      high: 10.0,
      low: 10.0,
      close: 10.0,
      volume: 1,
    ));

    for (var c in candles) {
      ema.addCandle(c);
    }

    // After many identical closes, current should equal 10
    expect(ema.current, 10.0);
  });
}
