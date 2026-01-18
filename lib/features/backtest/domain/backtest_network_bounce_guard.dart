import '../../../core/network/retry/retry_with_backoff.dart';

class BacktestNetworkBounceGuard {
  final int maxRetries;

  BacktestNetworkBounceGuard({this.maxRetries = 5});

  Future<T> safeFetch<T>(Future<T> Function() fetchFn) {
    return retryWithBackoff(fetchFn, retries: maxRetries);
  }
}
