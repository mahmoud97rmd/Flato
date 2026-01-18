Future<T> retryWithBackoff<T>(
    Future<T> Function() fn, {
    int retries = 3,
    Duration delay = const Duration(milliseconds: 500),
  }) async {
  try {
    return await fn();
  } catch (e) {
    if (retries > 0) {
      await Future.delayed(delay);
      return retryWithBackoff(fn, retries: retries - 1, delay: delay * 2);
    }
    rethrow;
  }
}
