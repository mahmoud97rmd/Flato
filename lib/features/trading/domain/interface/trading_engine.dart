import '../order/order.dart';

abstract class TradingEngine {
  Future<Order> sendOrder(Order order);
  void cancelOrder(String orderId);
  List<Order> activeOrders();
}
