class TrendlineMappingFix {
  static double mapPriceToY({
    required double price,
    required double minPrice,
    required double maxPrice,
    required double height,
  }) {
    final range = maxPrice - minPrice;
    return (maxPrice - price) / (range == 0 ? 1 : range) * height;
  }

  static double mapTimeToX({
    required DateTime time,
    required DateTime start,
    required DateTime end,
    required double width,
  }) {
    final total = end.difference(start).inMilliseconds;
    final delta = time.difference(start).inMilliseconds;
    return width * (total == 0 ? 0 : delta / total);
  }
}
