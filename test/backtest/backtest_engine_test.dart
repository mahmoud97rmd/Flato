import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/backtest/backtest_engine.dart';
import 'package:your_app/features/strategy/domain/evaluator/example_strategy.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  test('Backtest basic run', () {
    final history = List.generate(50, (i) => CandleEntity(
      instrument: "EUR_USD",
      timeUtc: DateTime.utc(2025,1,1,0,i),
      open: i.toDouble(),
      high: i.toDouble()+1,
      low: i.toDouble()-1,
      close: i.toDouble(),
      volume: 1,
    ));

    final engine = BacktestEngine(
      history: history,
      evaluator: buildExampleStrategy(),
      initialBalance: 10000,
      takeProfit: 0.01,
      stopLoss: 0.005,
    );

    final result = engine.run();
    expect(result.equityCurve.length, history.length);
    expect(result.netProfit, isA<double>());
    expect(result.winRate, inInclusiveRange(0.0, 1.0));
  });
}
