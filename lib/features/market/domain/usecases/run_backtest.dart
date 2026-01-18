import '../backtest/backtest_engine.dart';
import '../backtest/backtest_result.dart';
import '../entities/candle.dart';

class RunBacktest {
  Future<BacktestResult> call(
    String symbol,
    String timeframe,
    DateTime? start,
    DateTime? end,
  ) async {
    // جلب التاريخ (مثلاً من Repo)
    final history = await repository.getHistoricalCandles(
      symbol: symbol,
      timeframe: timeframe,
      start: start,
      end: end,
    );

    final engine = BacktestEngine(history);
    return engine.run();
  }
}
