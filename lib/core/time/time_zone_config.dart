class TimeZoneConfig {
  static const Map<String, int> instrumentOffsets = {
    "BTC_USD": -4, // مثال EDT
    "EUR_USD": 0,  // UTC
    "AAPL": -5     // EST
  };

  static DateTime toLocal(String symbol, DateTime utc) {
    final offset = instrumentOffsets[symbol] ?? 0;
    return utc.add(Duration(hours: offset));
  }
}
