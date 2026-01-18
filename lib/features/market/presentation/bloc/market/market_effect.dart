abstract class MarketEffect {}

class ShowToast extends MarketEffect {
  final String message;
  ShowToast(this.message);
}

class NavigateToSettings extends MarketEffect {}

class NotifyTradeOpened extends MarketEffect {
  final String symbol;
  NotifyTradeOpened(this.symbol);
}
