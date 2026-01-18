import '../../../features/trading/domain/order/order.dart';

class TradeStatistics {
  final List<Order> orders;

  TradeStatistics(this.orders);

  double get totalProfit => orders.fold(0.0, (sum, o) => sum + (o.filledLots * o.price));

  double get winRate {
    final wins = orders.where((o) => o.price > 0).length;
    return orders.isEmpty ? 0 : wins / orders.length;
  }

  double get maxDrawdown {
    // مثال تقريبي
    double peak = 0;
    double drawdown = 0;
    double equity = 0;
    for (var o in orders) {
      equity += o.price;
      if (equity > peak) peak = equity;
      drawdown = peak - equity;
    }
    return drawdown;
  }
}
