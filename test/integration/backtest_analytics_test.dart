import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/analytics/analytics_calculator.dart';
import 'package:your_app/features/market/domain/backtest/backtest_engine.dart';

void main() {
  test('Backtest integration yields expected analytics', () {
    final history = [
      // صيغة بيانات تجريبية
      CandleEntity(open: 100, high: 105, low: 95, close: 102, volume: 1000),
      CandleEntity(open: 102, high: 108, low: 99, close: 105, volume: 1200),
      CandleEntity(open: 105, high: 110, low: 102, close: 108, volume: 1100),
    ];

    final backtestEngine = BacktestEngine(history);
    final results = backtestEngine.run();

    final analytics = AnalyticsCalculator.calculate(results.tradeProfits);

    expect(analytics.totalTrades, greaterThan(0));
    expect(analytics.winRate, isA<double>());
  });
}
