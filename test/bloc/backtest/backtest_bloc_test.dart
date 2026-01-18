import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/market/presentation/bloc/backtest/backtest_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/backtest/backtest_event.dart';
import 'package:your_app/features/market/presentation/bloc/backtest/backtest_state.dart';
import '../../../mocks.dart';
import '../../../../core/models/candle_entity.dart';

void main() {
  blocTest<BacktestBloc, BacktestState>(
    'emits [Running, Success] when backtest runs without cancellation',
    build: () => BacktestBloc(),
    act: (bloc) => bloc.add(RunBacktest(
      history: [
        CandleEntity(
            instrument: "EUR_USD",
            timeUtc: DateTime.utc(2025, 1, 1),
            open: 1.0,
            high: 1.1,
            low: 0.9,
            close: 1.05,
            volume: 1)
      ],
      strategyId: "example",
    )),
    expect: () => [
      isA<BacktestRunning>(),
      isA<BacktestSuccess>(),
    ],
  );
}
