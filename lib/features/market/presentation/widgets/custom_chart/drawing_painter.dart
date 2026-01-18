import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> trendlines;
  final List<double> horizontalLines;

  DrawingPainter({
    required this.trendlines,
    required this.horizontalLines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintTrend = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2.0;

    final paintHLine = Paint()
      ..color = Colors.orange
      ..strokeWidth = 1.0;

    // Trendlines
    for (var line in trendlines) {
      if (line.length >= 2) {
        canvas.drawLine(line[0], line[1], paintTrend);
      }
    }

    // Horizontal lines
    for (var y in horizontalLines) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paintHLine,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter old) {
    return old.trendlines != trendlines ||
        old.horizontalLines != horizontalLines;
  }
}
