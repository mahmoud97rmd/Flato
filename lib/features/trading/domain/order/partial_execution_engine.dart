import 'dart:math';
import 'order.dart';

class PartialExecutionEngine {
  final Random _rng = Random();

  Order execute(Order order) {
    // محاكاة تنفيذ جزئي
    final fill = order.requestedLots * (0.5 + _rng.nextDouble() * 0.5);

    order.fill(fill);
    return order;
  }
}
