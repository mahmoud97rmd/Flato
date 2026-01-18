import 'dart:async';

class ModeStreamManager {
  final List<StreamSubscription> _streams = [];

  void register(StreamSubscription sub) => _streams.add(sub);

  Future<void> clearAll() async {
    for (final s in _streams) {
      await s.cancel();
    }
    _streams.clear();
  }
}
