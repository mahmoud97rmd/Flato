import 'dart:async';

class RetryLimiter {
  final int maxAttempts;
  final Duration baseDelay;

  RetryLimiter({this.maxAttempts = 3, this.baseDelay = const Duration(seconds: 1)});

  Future<T?> run<T>(Future<T> Function() fn) async {
    int attempts = 0;

    while (attempts < maxAttempts) {
      try {
        return await fn();
      } catch (e) {
        attempts++;
        await Future.delayed(baseDelay * attempts);
      }
    }
    return null;
  }
}
