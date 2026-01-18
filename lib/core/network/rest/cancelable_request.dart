import 'dart:async';

class CancelableRequest {
  bool _cancelled = false;

  void cancel() => _cancelled = true;

  Future<T?> execute<T>(Future<T> Function() fn) async {
    if (_cancelled) return null;
    final result = await fn();
    if (_cancelled) return null;
    return result;
  }
}
