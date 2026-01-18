import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/indicators/ema_calculator.dart';
import 'package:your_app/market/domain/entities/candle.dart';

void main() {
  test('EMA returns correct length and values', () {
    final data = List.generate(10, (i) => CandleEntity(
      time: DateTime.now().add(Duration(minutes: i)),
      open: i.toDouble(),
      high: i.toDouble() + 1,
      low: i.toDouble() - 1,
      close: i.toDouble(),
      volume: 1,
    ));

    final ema = EMACalculator.calculate(data, 5).values;

    expect(ema.length, 10);
    expect(ema.skip(4).first,
      greaterThan(ema.skip(3).first));
  });
}
