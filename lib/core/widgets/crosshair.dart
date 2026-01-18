import 'package:flutter/material.dart';

class CrosshairPainter extends CustomPainter {
  final Offset position;
  final XAxisRange visibleRange;
  final double minPrice;
  final double maxPrice;

  CrosshairPainter({
    required this.position,
    required this.visibleRange,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 1;

    // Vertical line
    canvas.drawLine(Offset(position.dx, 0), Offset(position.dx, size.height), paint);

    // Horizontal line
    canvas.drawLine(Offset(0, position.dy), Offset(size.width, position.dy), paint);
  }

  @override
  bool shouldRepaint(covariant CrosshairPainter old) => old.position != position;
}
