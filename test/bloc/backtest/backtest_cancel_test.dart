import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/market/presentation/bloc/backtest/backtest_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/backtest/backtest_event.dart';
import 'package:your_app/features/market/presentation/bloc/backtest/backtest_state.dart';

void main() {
  blocTest<BacktestBloc, BacktestState>(
    'emits Cancelled when cancel event is added',
    build: () => BacktestBloc(),
    act: (bloc) {
      bloc.add(RunBacktest(history: [], strategyId: "", takeProfit: 0, stopLoss: 0));
      bloc.add(CancelBacktest());
    },
    expect: () => [isA<BacktestRunning>(), isA<BacktestCancelled>()],
  );
}
