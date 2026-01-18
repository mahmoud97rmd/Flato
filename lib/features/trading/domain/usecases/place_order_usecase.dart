import '../interface/trading_engine.dart';
import '../order/order.dart';

class PlaceOrderUseCase {
  final TradingEngine engine;

  PlaceOrderUseCase(this.engine);

  Future<Order> call(Order order) => engine.sendOrder(order);
}
