import '../../../../market/domain/backtest/backtest_models.dart';

abstract class TradingState {}

class TradingInitial extends TradingState {}

class TradingLoading extends TradingState {}

class TradingPositionsLoaded extends TradingState {
  final List<Position> positions;
  TradingPositionsLoaded(this.positions);
}

class TradingOrderSuccess extends TradingState {
  final String message;
  TradingOrderSuccess(this.message);
}

class TradingFailure extends TradingState {
  final String error;
  TradingFailure(this.error);
}
