import 'dart:async';

extension HttpTimeout<T> on Future<T> {
  Future<T> withTimeout(Duration timeout) {
    return this.timeout(timeout, onTimeout: () {
      throw Exception("Request Timeout after \$timeout");
    });
  }
}
