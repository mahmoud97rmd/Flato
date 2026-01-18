import 'dart:async';

class WsSubscriptionRegistry {
  final List<StreamSubscription> _subs = [];

  void register(StreamSubscription sub) => _subs.add(sub);

  Future<void> clearAll() async {
    for (final sub in _subs) {
      await sub.cancel();
    }
    _subs.clear();
  }
}
