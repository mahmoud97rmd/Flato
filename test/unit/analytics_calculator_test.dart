import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/analytics/analytics_calculator.dart';

void main() {
  group('AnalyticsCalculator', () {
    test('calculates correct metrics', () {
      final profits = [100.0, -50.0, 25.0];

      final result = AnalyticsCalculator.calculate(profits);

      expect(result.netProfit, 75.0);
      expect(result.totalTrades, 3);
      expect(result.wins, 2);
      expect(result.losses, 1);
      expect(result.winRate, closeTo(66.67, 0.1));
    });
  });
}
