import 'package:flutter/material.dart';

class DrawToolMappingFix {
  static Offset toScreen(
      {required DateTime time,
      required double price,
      required DateTime start,
      required DateTime end,
      required double minPrice,
      required double maxPrice,
      required Size size}) {
    final px = (time.millisecondsSinceEpoch - start.millisecondsSinceEpoch) /
        (end.millisecondsSinceEpoch - start.millisecondsSinceEpoch);
    final py = (price - minPrice) / (maxPrice - minPrice);

    return Offset(px * size.width, (1 - py) * size.height);
  }

  static Map<String, dynamic> fromScreen(Offset point, Size size,
      DateTime start, DateTime end, double minPrice, double maxPrice) {
    final px = point.dx / size.width;
    final py = 1 - (point.dy / size.height);

    final time = DateTime.fromMillisecondsSinceEpoch(
        start.millisecondsSinceEpoch +
            (end.millisecondsSinceEpoch - start.millisecondsSinceEpoch) *
                px.toInt());
    final price = minPrice + (maxPrice - minPrice) * py;
    return {"time": time, "price": price};
  }
}
