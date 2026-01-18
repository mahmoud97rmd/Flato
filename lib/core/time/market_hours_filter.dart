class MarketHoursFilter {
  static bool isMarketOpen(DateTime timeUtc) {
    final weekday = timeUtc.weekday;
    final hour = timeUtc.hour;
    // أمثلة (Forex): من الأحد 22:00 إلى الجمعة 22:00 UTC
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) return false;
    if (hour < 22 && weekday == DateTime.sunday) return false;
    return true;
  }
}
