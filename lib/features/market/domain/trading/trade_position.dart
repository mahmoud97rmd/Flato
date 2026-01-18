import '../entities/candle.dart';

enum TradeType { BUY, SELL }

class TradePosition {
  final String instrument;
  final TradeType type;
  final DateTime entryTime;
  final double entryPrice;
  final double stopLoss;
  final double takeProfit;
  double? exitPrice;
  DateTime? exitTime;

  TradePosition({
    required this.instrument,
    required this.type,
    required this.entryTime,
    required this.entryPrice,
    required this.stopLoss,
    required this.takeProfit,
  });
}
