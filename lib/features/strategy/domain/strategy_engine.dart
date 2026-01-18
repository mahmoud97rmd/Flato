import 'strategy_model.dart';

class StrategyEngine {
  final List<StrategyModel> strategies;

  StrategyEngine(this.strategies);

  String? evaluate(List<String> activeSignals) {
    for (final strategy in strategies) {
      if (strategy.canTrigger(activeSignals)) return strategy.action;
    }
    return null;
  }
}
