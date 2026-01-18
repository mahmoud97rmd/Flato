import 'package:flutter/material.dart';
import '../../../market/domain/indicators/types/indicator_series.dart';
import 'chart_utils/chart_mapper.dart';
import '../../../market/domain/chart/x_axis_range.dart';

class OverlayIndicatorsPainter extends CustomPainter {
  final List<IndicatorSeries> seriesList;
  final List<DateTime> times;
  final XAxisRange visibleRange;
  final double minPrice;
  final double maxPrice;

  OverlayIndicatorsPainter({
    required this.seriesList,
    required this.times,
    required this.visibleRange,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var series in seriesList) {
      final paint = Paint()
        ..color = series.color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      Path path = Path();
      bool started = false;

      for (int i = 0; i < times.length; i++) {
        if (!visibleRange.contains(times[i])) continue;

        final x = timeToPx(times[i], visibleRange, size.width);
        final y = priceToPx(series.values[i], minPrice, maxPrice, size.height);

        if (!started) {
          path.moveTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant OverlayIndicatorsPainter old) => true;
}
