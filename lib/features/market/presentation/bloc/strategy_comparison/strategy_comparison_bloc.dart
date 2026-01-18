import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/strategy/multi/multi_strategy_runner.dart';
import 'strategy_comparison_event.dart';
import 'strategy_comparison_state.dart';

class StrategyComparisonBloc extends Bloc<ComparisonEvent, ComparisonState> {
  StrategyComparisonBloc() : super(ComparisonIdle()) {
    on<RunComparison>(_onRun);
  }

  void _onRun(RunComparison event, Emitter<ComparisonState> emit) async {
    emit(ComparisonRunning());
    try {
      final runner = MultiStrategyRunner(event.set);
      final results = await runner.runBacktestAll(event.history);
      emit(ComparisonSuccess(results.results));
    } catch (e) {
      emit(ComparisonError("Comparison failed: \$e"));
    }
  }
}
