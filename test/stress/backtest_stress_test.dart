import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/backtest/backtest_engine.dart';
import 'package:your_app/features/strategy/domain/evaluator/example_strategy.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  test('Backtest handles 10000 candles in <1 second', () {
    final history = List.generate(10000, (i) => CandleEntity(
      instrument: "XAU_USD",
      timeUtc: DateTime.utc(2025,1,1,0,i),
      open: i.toDouble(),
      high: i.toDouble()+1,
      low: i.toDouble(),
      close: i.toDouble(),
      volume: 1,
    ));

    final engine = BacktestEngine(history: history, evaluator: buildExampleStrategy());
    final stopwatch = Stopwatch()..start();
    engine.run();
    stopwatch.stop();

    expect(stopwatch.elapsed.inSeconds < 1, true);
  });
}
