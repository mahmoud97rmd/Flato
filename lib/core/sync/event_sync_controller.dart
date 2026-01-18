import 'dart:async';

/// Ensures only one update type is processed at a time.
/// Other events wait in queue.
class EventSyncController {
  final _queue = StreamController<Function()>();

  EventSyncController() {
    _queue.stream.asyncMap((task) => Future(() => task())).listen((_) {});
  }

  /// add an event to execution queue
  void addToQueue(void Function() task) {
    _queue.add(task);
  }

  Future<void> close() async {
    await _queue.close();
  }
}
