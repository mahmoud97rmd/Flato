abstract class StreamRepository {
  Stream<Map<String, dynamic>> ticks();
  Future<void> start({
    required String accountId,
    required String instruments,
    required Map<String, String> headers,
  });
  void stop();
}
