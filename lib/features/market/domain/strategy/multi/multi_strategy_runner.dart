import '../strategy_config.dart';
import '../../backtest/backtest_engine.dart';
import 'strategy_set.dart';

class MultiStrategyResult {
  final Map<String, dynamic> results;
  MultiStrategyResult({required this.results});
}

class MultiStrategyRunner {
  final StrategySet strategySet;

  MultiStrategyRunner(this.strategySet);

  Future<MultiStrategyResult> runBacktestAll(List<dynamic> history) async {
    final Map<String, dynamic> out = {};

    for (var inst in strategySet.strategies) {
      final engine = BacktestEngine(history, config: inst.config);
      final res = engine.run();
      out[inst.id] = res;
    }

    return MultiStrategyResult(results: out);
  }
}
