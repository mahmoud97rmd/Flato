class PriceAlert {
  final double price;
  final bool triggerAbove;
  final String symbol;

  PriceAlert({
    required this.price,
    required this.triggerAbove,
    required this.symbol,
  });
}
