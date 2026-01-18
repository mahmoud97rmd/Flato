import 'package:flutter/material.dart';
import '../../../domain/chart/x_axis_range.dart';
import '../../../domain/entities/candle.dart';

double mapTimeToX(DateTime time, XAxisRange range, double width) {
  final total = range.max.millisecondsSinceEpoch - range.min.millisecondsSinceEpoch;
  final delta = time.millisecondsSinceEpoch - range.min.millisecondsSinceEpoch;
  return (delta / total) * width;
}

double mapPriceToY(double price, double minPrice, double maxPrice, double height) {
  return height * (1 - ((price - minPrice) / (maxPrice - minPrice)));
}
