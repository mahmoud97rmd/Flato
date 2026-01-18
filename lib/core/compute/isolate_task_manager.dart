import 'dart:isolate';

class IsolateTaskManager {
  final List<Isolate> _isolates = [];

  Future<Isolate> spawn(Function entry) async {
    final iso = await Isolate.spawn(entry, null);
    _isolates.add(iso);
    return iso;
  }

  void killAll() {
    for (final iso in _isolates) {
      iso.kill(priority: Isolate.immediate);
    }
    _isolates.clear();
  }
}
