import 'package:flutter_bloc/flutter_bloc.dart';
import 'backtest_event.dart';
import 'backtest_state.dart';
import '../../../../features/market/domain/backtest/backtest_engine.dart';
import '../../../../features/strategy/domain/evaluator/example_strategy.dart';
import '../../../../core/models/candle_entity.dart';

class BacktestBloc extends Bloc<BacktestEvent, BacktestState> {
  BacktestBloc() : super(BacktestInitial()) {
    on<RunBacktest>(_onRunBacktest);
    on<CancelBacktest>(_onCancelBacktest);
  }

  bool _cancelRequested = false;

  Future<void> _onRunBacktest(RunBacktest event, Emitter<BacktestState> emit) async {
    emit(BacktestRunning());
    _cancelRequested = false;

    try {
      // ترجمة strategyId إلى StrategyEvaluator
      // هنا افتراضيا نستخدم مثال
      final evaluator = buildExampleStrategy();

      final engine = BacktestEngine(
        history: event.history.cast<CandleEntity>(),
        evaluator: evaluator,
        takeProfit: event.takeProfit,
        stopLoss: event.stopLoss,
      );

      final result = engine.run();

      if (_cancelRequested) {
        emit(BacktestCancelled());
      } else {
        emit(BacktestSuccess(result));
      }
    } catch (e) {
      emit(BacktestError(e.toString()));
    }
  }

  void _onCancelBacktest(CancelBacktest event, Emitter<BacktestState> emit) {
    _cancelRequested = true;
    emit(BacktestCancelled());
  }
}
