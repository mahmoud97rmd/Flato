abstract class MarketEvent {}

class LoadHistory extends MarketEvent {
  final String accountId;
  final String symbol;
  final String timeframe;

  LoadHistory(this.accountId, this.symbol, this.timeframe);
}

class StartStreaming extends MarketEvent {}

class StopStreaming extends MarketEvent {}
