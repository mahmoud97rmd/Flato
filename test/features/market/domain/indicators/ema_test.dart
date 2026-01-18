import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/indicators/ema_calculator.dart';
import '../../../mock/candles_mock.dart';

void main() {
  test('EMA calculation basic', () {
    final candles = generateMockCandles(100);
    final result = EmaCalculator.calculate(data: candles, period: 10);
    expect(result.values.length, candles.length);
    expect(result.values.first, candles.first.close);
  });
}
