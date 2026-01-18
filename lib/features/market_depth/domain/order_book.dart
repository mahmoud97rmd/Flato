class OrderBookLevel {
  final double price;
  final double volume;
  OrderBookLevel(this.price, this.volume);
}

class OrderBook {
  final List<OrderBookLevel> bids;
  final List<OrderBookLevel> asks;

  OrderBook({required this.bids, required this.asks});
}
