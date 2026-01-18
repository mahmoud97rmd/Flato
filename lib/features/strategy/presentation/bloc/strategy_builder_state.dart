import '../../../../core/models/strategy_graph.dart';

abstract class StrategyBuilderState {}

class BuilderInitial extends StrategyBuilderState {}

class BuilderLoaded extends StrategyBuilderState {
  final StrategyGraph graph;
  BuilderLoaded(this.graph);
}

class BuilderError extends StrategyBuilderState {
  final String message;
  BuilderError(this.message);
}
