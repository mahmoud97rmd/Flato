import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/backtest/backtest_engine.dart';
import 'package:your_app/features/strategy/domain/evaluator/example_strategy.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  test('Backtest net profit should accumulate correctly', () {
    // Construct history where price moves up
    final history = [
      CandleEntity(instrument: "EUR_USD", timeUtc: DateTime.utc(2025,1,1), open: 1.0, high: 2.0, low: 1.0, close: 1.5, volume: 1),
      CandleEntity(instrument: "EUR_USD", timeUtc: DateTime.utc(2025,1,1,0,1), open: 1.5, high: 2.5, low: 1.5, close: 2.0, volume: 1),
    ];

    final engine = BacktestEngine(
      history: history,
      evaluator: buildExampleStrategy(),
      initialBalance: 1000,
      takeProfit: 0,
      stopLoss: 0,
    );

    final result = engine.run();

    expect(result.netProfit, greaterThan(0));
    expect(result.equityCurve.last, greaterThan(result.equityCurve.first));
  });
}
