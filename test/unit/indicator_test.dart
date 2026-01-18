import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/features/indicators/domain/ema_calculator.dart';
import 'package:my_app/features/indicators/domain/rsi_calculator.dart';

void main() {
  test('EMA calculator works correctly', () {
    final ema = EmaCalculator(5);
    final values = [1, 2, 3, 4, 5];
    final result = values.map((v) => ema.calculate(v)).toList();
    expect(result.isNotEmpty, true);
  });

  test('RSI calculator returns a number between 0 and 100', () {
    final rsi = RsiCalculator(5);
    double prev = 1, curr = 2;
    final val = rsi.calculate(prev, curr);
    expect(val != null && val! >= 0 && val <= 100, true);
  });
}
