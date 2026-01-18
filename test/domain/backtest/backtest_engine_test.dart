import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/backtest/backtest_engine.dart';
import 'package:your_app/market/domain/entities/candle.dart';

void main() {
  test('Backtest should return correct stats', () {
    final history = List.generate(30, (i) => CandleEntity(
      time: DateTime.now().add(Duration(minutes: i)),
      open: i.toDouble(),
      high: i.toDouble() + 1,
      low: i.toDouble() - 1,
      close: i.isEven ? i.toDouble() + 1 : i.toDouble() - 1,
      volume: 1,
    ));

    final engine = BacktestEngine(history: history, strategy: /* your test strategy */);
    final result = engine.run();

    expect(result.equityCurve.first, 10000);
    expect(result.totalTrades, isNonNegative);
  });
}
