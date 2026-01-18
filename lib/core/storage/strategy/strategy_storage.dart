import '../../../../core/models/strategy_graph.dart';

abstract class StrategyStorage {
  Future<void> save(String id, StrategyGraph graph);
  Future<StrategyGraph> load(String id);
}
