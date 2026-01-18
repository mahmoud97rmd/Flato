enum OrderStatus { pending, partiallyFilled, filled, rejected }

class Order {
  final String id;
  final String symbol;
  final double requestedLots;
  double filledLots;
  final double price;
  final DateTime createdAt;
  DateTime? executedAt;
  OrderStatus status;

  Order({
    required this.id,
    required this.symbol,
    required this.requestedLots,
    required this.filledLots,
    required this.price,
    DateTime? createdAt,
    this.executedAt,
    this.status = OrderStatus.pending,
  }) : createdAt = createdAt ?? DateTime.now().toUtc();

  double get remainingLots => requestedLots - filledLots;

  void markExecuted() {
    executedAt = DateTime.now().toUtc();
    status = OrderStatus.filled;
  }
}
