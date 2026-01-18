class MarketHoursFilterFix {
  static bool isMarketOpen(DateTime t) {
    final utc = t.toUtc();
    final weekday = utc.weekday;
    // Forex example:
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
      return false;
    }
    return true;
  }
}
