class SyncAligner {
  final Duration bufferDelay = Duration(milliseconds: 500);

  DateTime align(DateTime input) {
    return input.add(bufferDelay);
  }
}
