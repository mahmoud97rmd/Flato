import 'dart:async';
import '../errors/execution_error.dart';
import 'order.dart';

class RetriableExecutionEngine {
  Future<Order> executeWithRetry(
    Order order, {
    int maxRetries = 3,
  }) async {
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        // هنا مكان ربط الـ API الحقيقي لاحقًا
        if (attempt == 0) throw ExecutionError(ExecutionErrorType.network, "Timeout");

        order.status = OrderStatus.filled;
        return order;
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: 500 * attempt));
      }
    }
    throw ExecutionError(ExecutionErrorType.timeout, "Max retries exceeded");
  }
}
