class SessionFilter {
  static bool isWithinMarketHours(DateTime utc) {
    final weekday = utc.weekday;
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) return false;
    return true;
  }
}
