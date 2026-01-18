import 'dart:ui';
import '../../../market/domain/chart/x_axis_range.dart';

/// Convert a timestamp (DateTime) to an X pixel
double timeToPx(DateTime t, XAxisRange range, double width) {
  final total = range.max.millisecondsSinceEpoch - range.min.millisecondsSinceEpoch;
  if (total == 0) return 0.0;
  final delta = t.millisecondsSinceEpoch - range.min.millisecondsSinceEpoch;
  return (delta / total) * width;
}

/// Convert a price to a Y pixel (inverted coordinate system)
double priceToPx(double price, double minPrice, double maxPrice, double height) {
  if (maxPrice - minPrice == 0) return height / 2;
  return height * (1 - (price - minPrice) / (maxPrice - minPrice));
}
