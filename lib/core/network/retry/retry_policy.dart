import 'dart:async';

enum RetryErrorType {
  timeout,
  server,
  client,
  unknown,
}

class RetryPolicy {
  final int maxAttempts;
  final Duration baseDelay;
  final bool enableJitter;

  RetryPolicy({
    this.maxAttempts = 5,
    this.baseDelay = const Duration(seconds: 1),
    this.enableJitter = true,
  });

  Duration _jitter(Duration d) {
    if (!enableJitter) return d;
    final millis = d.inMilliseconds;
    final jitter = (millis * 0.5).toInt();
    return Duration(milliseconds: millis + jitter);
  }

  Future<T> execute<T>(
    Future<T> Function() action, {
    required void Function(int attempt, Duration delay, RetryErrorType type) onRetry,
  }) async {
    int attempts = 0;
    Duration delay = baseDelay;

    while (true) {
      try {
        return await action();
      } catch (e) {
        attempts++;
        if (attempts >= maxAttempts) rethrow;

        final errorType = _classifyError(e);

        // Logging retry attempt
        onRetry(attempts, delay, errorType);

        await Future.delayed(_jitter(delay));

        // Exponential backoff
        delay = Duration(seconds: delay.inSeconds * 2);
      }
    }
  }

  RetryErrorType _classifyError(Object error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains("timeout")) return RetryErrorType.timeout;
    if (msg.contains("5")) return RetryErrorType.server;
    if (msg.contains("4")) return RetryErrorType.client;
    return RetryErrorType.unknown;
  }
}
