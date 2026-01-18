import 'dart:async';

class SubscriptionManager {
  final List<StreamSubscription> _subs = [];

  void add(StreamSubscription sub) {
    _subs.add(sub);
  }

  Future<void> cancelAll() async {
    for (final s in _subs) {
      await s.cancel();
    }
    _subs.clear();
  }
}
