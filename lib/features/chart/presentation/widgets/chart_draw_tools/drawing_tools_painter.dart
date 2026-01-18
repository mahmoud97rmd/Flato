import 'package:flutter/material.dart';

class DrawingToolsPainter extends CustomPainter {
  final List<Offset> trendPoints;

  DrawingToolsPainter({required this.trendPoints});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2.0;

    if (trendPoints.length >= 2) {
      canvas.drawLine(trendPoints[0], trendPoints[1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingToolsPainter old) {
    return old.trendPoints != trendPoints;
  }
}
