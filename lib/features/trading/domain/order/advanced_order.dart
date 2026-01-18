enum OrderType { market, limit, stop, stopLimit }

class AdvancedOrder {
  final String id;
  final String symbol;
  final OrderType type;
  final double price;
  final double stopPrice;
  final double lots;

  AdvancedOrder({
    required this.id,
    required this.symbol,
    this.type = OrderType.market,
    this.price = 0,
    this.stopPrice = 0,
    required this.lots,
  });
}
