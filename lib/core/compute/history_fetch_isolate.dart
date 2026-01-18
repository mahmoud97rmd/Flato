import 'dart:isolate';

class HistoryFetchIsolate {
  static Future<List<dynamic>> run(fetchFn) =>
      Isolate.run(() => fetchFn());
}
