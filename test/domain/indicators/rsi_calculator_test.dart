import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/indicators/rsi_calculator.dart';
import 'package:your_app/market/domain/entities/candle.dart';

void main() {
  test('RSI simple test', () {
    final data = List.generate(20, (i) => CandleEntity(
      time: DateTime.now().add(Duration(minutes: i)),
      open: i.toDouble(),
      high: i.toDouble(),
      low: i.toDouble(),
      close: i.toDouble() + 1,
      volume: 1,
    ));

    final rsi = RSICalculator.calculate(data, 14).values;
    expect(rsi.length, greaterThan(0));
    expect(rsi.first, isNonNegative);
  });
}
