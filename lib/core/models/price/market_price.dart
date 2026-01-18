enum PriceType { bid, ask, mid }

class MarketPrice {
  final double bid;
  final double ask;

  MarketPrice({required this.bid, required this.ask});

  double of(PriceType type) {
    switch (type) {
      case PriceType.bid:
        return bid;
      case PriceType.ask:
        return ask;
      case PriceType.mid:
        return (bid + ask) / 2;
    }
  }
}
