class TimeFormatter {
  static String format(DateTime utc) {
    return utc.toLocal().toIso8601String();
  }
}
