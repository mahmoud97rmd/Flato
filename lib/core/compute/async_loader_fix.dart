import 'dart:isolate';

Future<T> runInIsolate<T>(T Function() fn) async {
  return await Isolate.run(fn);
}
