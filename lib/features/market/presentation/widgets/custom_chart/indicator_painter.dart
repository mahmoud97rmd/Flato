import 'package:flutter/material.dart';

class IndicatorPainter extends CustomPainter {
  final List<Offset> linePoints;
  final Color color;

  IndicatorPainter({required this.linePoints, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (linePoints.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawPoints(PointMode.polygon, linePoints, paint);
  }

  @override
  bool shouldRepaint(covariant IndicatorPainter old) =>
      old.linePoints != linePoints;
}
