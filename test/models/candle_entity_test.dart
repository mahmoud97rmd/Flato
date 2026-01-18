import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  test('CandleEntity UTC conversion & fields', () {
    final json = {
      "time": "2025-01-01T10:00:00Z",
      "open": "100",
      "high": "110",
      "low": "90",
      "close": "105",
      "volume": "1000"
    };

    final candle = CandleEntity.fromJson("EUR_USD", json);

    expect(candle.instrument, "EUR_USD");
    expect(candle.timeUtc.isUtc, true);
    expect(candle.open, 100.0);
    expect(candle.high, 110.0);
    expect(candle.close, 105.0);
  });
}
