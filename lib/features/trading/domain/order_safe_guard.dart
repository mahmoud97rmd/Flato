import 'order.dart';

class OrderSafeGuard {
  static bool isValid(Order? order) {
    if (order == null) return false;
    if (order.symbol.isEmpty) return false;
    if (order.lots <= 0) return false;
    return true;
  }
}
