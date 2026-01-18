import 'package:flutter/material.dart';
import '../../../domain/chart/x_axis_range.dart';
import '../utils/chart_mapping.dart';

class RSIChartPainter extends CustomPainter {
  final List<DateTime> times;
  final List<double> values;
  final XAxisRange visibleRange;

  RSIChartPainter({required this.times, required this.values, required this.visibleRange});

  @override
  void paint(Canvas canvas, Size size) {
    final paintRsi = Paint()..color = Colors.purple..strokeWidth = 1.5;

    double maxVal = values.reduce((a, b) => a > b ? a : b);
    double minVal = values.reduce((a, b) => a < b ? a : b);

    for (int i = 0; i < times.length; i++) {
      if (!visibleRange.contains(times[i])) continue;
      final x = mapTimeToX(times[i], visibleRange, size.width);
      final y = mapPriceToY(values[i], minVal, maxVal, size.height);
      if (i > 0 && visibleRange.contains(times[i-1])) {
        final prevX = mapTimeToX(times[i-1], visibleRange, size.width);
        final prevY = mapPriceToY(values[i-1], minVal, maxVal, size.height);
        canvas.drawLine(Offset(prevX, prevY), Offset(x, y), paintRsi);
      }
    }
  }

  @override
  bool shouldRepaint(covariant RSIChartPainter old) => old.times != times || old.visibleRange != visibleRange;
}
