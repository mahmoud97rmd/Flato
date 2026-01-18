class RejectLogger {
  final List<String> rejected = [];

  void log(String orderId, String reason) {
    rejected.add("${DateTime.now().toUtc().toIso8601String()} | $orderId | $reason");
  }
}
