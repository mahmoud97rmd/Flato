import '../../../domain/strategy/multi/strategy_set.dart';

abstract class ComparisonEvent {}

class RunComparison extends ComparisonEvent {
  final StrategySet set;
  final List history;
  RunComparison({required this.set, required this.history});
}
