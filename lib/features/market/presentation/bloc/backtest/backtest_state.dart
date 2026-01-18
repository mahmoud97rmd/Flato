import '../../../../features/market/domain/backtest/backtest_result.dart';

abstract class BacktestState {}

class BacktestInitial extends BacktestState {}

class BacktestRunning extends BacktestState {}

class BacktestSuccess extends BacktestState {
  final BacktestResult result;
  BacktestSuccess(this.result);
}

class BacktestError extends BacktestState {
  final String message;
  BacktestError(this.message);
}

class BacktestCancelled extends BacktestState {}
