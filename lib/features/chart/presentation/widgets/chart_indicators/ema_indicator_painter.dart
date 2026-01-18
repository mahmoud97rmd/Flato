import 'package:flutter/material.dart';

class EMAIndicatorPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;

  EMAIndicatorPainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var p in points.skip(1)) path.lineTo(p.dx, p.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant EMAIndicatorPainter old) =>
      old.points != points;
}
