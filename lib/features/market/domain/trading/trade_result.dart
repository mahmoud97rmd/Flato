class TradeResult {
  final double profit;
  final double entryPrice;
  final double exitPrice;
  final DateTime entryTime;
  final DateTime exitTime;

  TradeResult({
    required this.profit,
    required this.entryPrice,
    required this.exitPrice,
    required this.entryTime,
    required this.exitTime,
  });
}
