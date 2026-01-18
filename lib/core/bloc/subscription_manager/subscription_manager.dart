import 'dart:async';

/// A manager that keeps only one active subscription at a time.
/// Cancels previous one automatically when a new one is added.
class SubscriptionManager {
  StreamSubscription<dynamic>? _current;

  /// Replace the current subscription with a new one,
  /// canceling the previous if it exists.
  void replace(StreamSubscription<dynamic> newSub) {
    _current?.cancel();
    _current = newSub;
  }

  /// Cancel and clear the current subscription.
  Future<void> dispose() async {
    if (_current != null) {
      await _current!.cancel();
      _current = null;
    }
  }
}
