import 'dart:async';

class BatchComputer {
  Future<void> processInBatches<T>(
      List<T> items,
      Future<void> Function(T) action,
      {int batchSize = 1000}) async {
    for (var i = 0; i < items.length; i += batchSize) {
      final batch = items.sublist(i, i + batchSize);
      await Future.wait(batch.map(action));
    }
  }
}
