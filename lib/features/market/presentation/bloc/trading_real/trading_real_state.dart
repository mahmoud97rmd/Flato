abstract class TradingRealState {}

class RealTradingIdle extends TradingRealState {}

class RealTradingInProgress extends TradingRealState {}

class RealTradingSuccess extends TradingRealState {
  final Map<String, dynamic> result;
  RealTradingSuccess(this.result);
}

class RealTradingError extends TradingRealState {
  final String message;
  RealTradingError(this.message);
}
