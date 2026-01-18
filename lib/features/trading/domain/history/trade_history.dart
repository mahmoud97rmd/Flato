class TradeHistory {
  final List<String> events = [];

  void log(String event) {
    events.add("${DateTime.now().toUtc().toIso8601String()} | $event");
  }
}
