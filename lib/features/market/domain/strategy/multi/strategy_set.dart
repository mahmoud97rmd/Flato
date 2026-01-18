import '../../strategy/strategy_config.dart';

class StrategyInstance {
  final String id;
  final StrategyConfig config;

  StrategyInstance({required this.id, required this.config});
}

class StrategySet {
  final List<StrategyInstance> strategies;

  StrategySet({required this.strategies});
}
