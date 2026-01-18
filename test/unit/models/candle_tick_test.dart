import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/features/market/domain/models/candle.dart';
import 'package:my_app/features/market/domain/models/tick.dart';

void main() {
  test('Candle from REST JSON parsing', () {
    final json = {
      "time": "2025-01-01T10:00:00Z",
      "o": "1.1",
      "h": "1.2",
      "l": "1.05",
      "c": "1.15",
      "volume": "100"
    };

    final c = Candle.fromRestJson(json);
    expect(c.open, 1.1);
    expect(c.high, 1.2);
    expect(c.low, 1.05);
    expect(c.close, 1.15);
    expect(c.volume, 100);
  });

  test('Tick from OANDA WS JSON', () {
    final json = {
      "type": "PRICE",
      "time": "2025-01-01T10:00:01Z",
      "bids": [
        {"price": "1.25"}
      ],
      "asks": [
        {"price": "1.26"}
      ]
    };

    final t = Tick.fromOandaWs(json);
    expect(t.bid, 1.25);
    expect(t.ask, 1.26);
  });
}
