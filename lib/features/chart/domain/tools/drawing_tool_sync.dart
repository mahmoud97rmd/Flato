class DrawingToolSync {
  double mapPriceToY({
    required double price,
    required double minPrice,
    required double maxPrice,
    required double height,
  }) {
    return height * (maxPrice - price) / (maxPrice - minPrice);
  }

  double mapTimeToX({
    required DateTime time,
    required DateTime start,
    required DateTime end,
    required double width,
  }) {
    final total = end.difference(start).inMilliseconds.toDouble();
    final delta = time.difference(start).inMilliseconds.toDouble();
    return width * (delta / total);
  }
}
