enum OrderSide { buy, sell }

class Order {
  final OrderSide side;
  final DateTime time;
  final double price;
  final double size;

  Order({
    required this.side,
    required this.time,
    required this.price,
    required this.size,
  });
}

class Position {
  final OrderSide side;
  final DateTime entryTime;
  final double entryPrice;
  final double size;
  DateTime? exitTime;
  double? exitPrice;

  Position({
    required this.side,
    required this.entryTime,
    required this.entryPrice,
    required this.size,
    this.exitPrice,
    this.exitTime,
  });

  double get profit {
    if (exitPrice == null) return 0.0;
    return (side == OrderSide.buy)
        ? (exitPrice! - entryPrice) * size
        : (entryPrice - exitPrice!) * size;
  }
}
