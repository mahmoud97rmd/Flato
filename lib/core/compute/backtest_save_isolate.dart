import 'dart:isolate';

Future<void> saveBacktestInIsolate(Function saveFn) async {
  await Isolate.run(saveFn);
}
