import '../../../domain/trading/orders/order_request.dart';

abstract class TradingRealEvent {}

class SubmitRealOrder extends TradingRealEvent {
  final OrderRequest order;
  SubmitRealOrder(this.order);
}
