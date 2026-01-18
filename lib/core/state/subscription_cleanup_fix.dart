import 'dart:async';

mixin SubscriptionCleanupFix {
  final List<StreamSubscription> _subs = [];

  void addSub(StreamSubscription sub) => _subs.add(sub);

  @override
  Future<void> close() async {
    for (final s in _subs) {
      await s.cancel();
    }
    _subs.clear();
    await super.close();
  }
}
