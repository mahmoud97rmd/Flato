import 'dart:async';

class OrderBookSync {
  final _queue = StreamController<Function()>();

  OrderBookSync() {
    _queue.stream.asyncMap((task) => Future(() => task())).listen((_) {});
  }

  void process(Function() updateFn) => _queue.add(updateFn);

  Future<void> dispose() async => _queue.close();
}
