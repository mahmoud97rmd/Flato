import 'dart:isolate';

class BacktestChunkedRunner {
  static Future<void> run(List dataset, void Function(dynamic) onResult) async {
    await Isolate.run(() async {
      for (final chunk in dataset) {
        onResult(chunk);
      }
    });
  }
}
