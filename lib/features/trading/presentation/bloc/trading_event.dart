part of 'trading_bloc.dart';

abstract class TradingEvent {}

class PlaceMarketOrder extends TradingEvent {
  final String symbol;
  final int units;
  final double? stopLoss;
  final double? takeProfit;

  PlaceMarketOrder({
    required this.symbol,
    required this.units,
    this.stopLoss,
    this.takeProfit,
  });
}

class PlaceLimitOrder extends TradingEvent {
  final String symbol;
  final int units;
  final double price;

  PlaceLimitOrder({
    required this.symbol,
    required this.units,
    required this.price,
  });
}
