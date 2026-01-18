import 'package:flutter/material.dart';
import '../../../market/domain/chart/x_axis_range.dart';
import 'chart_utils/chart_mapper.dart';

class RSIChartPainter extends CustomPainter {
  final List<DateTime> times;
  final List<double> values;
  final XAxisRange visibleRange;

  RSIChartPainter({required this.times, required this.values, required this.visibleRange});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.purple..strokeWidth = 1.5;

    double maxVal = values.reduce((a, b) => a > b ? a : b);
    double minVal = values.reduce((a, b) => a < b ? a : b);

    Path path = Path();
    bool started = false;

    for (int i = 0; i < times.length; i++) {
      if (!visibleRange.contains(times[i])) continue;

      final x = timeToPx(times[i], visibleRange, size.width);
      final y = priceToPx(values[i], minVal, maxVal, size.height);

      if (!started) {
        path.moveTo(x, y);
        started = true;
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant RSIChartPainter old) => true;
}
