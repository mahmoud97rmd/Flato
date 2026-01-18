import 'package:flutter/material.dart';

class CrosshairOverlay extends StatelessWidget {
  final Offset? position;

  const CrosshairOverlay({required this.position});

  @override
  Widget build(BuildContext context) {
    if (position == null) return SizedBox.shrink();
    return CustomPaint(
      painter: _CrosshairPainter(position!),
      size: Size.infinite,
    );
  }
}

class _CrosshairPainter extends CustomPainter {
  final Offset pos;

  _CrosshairPainter(this.pos);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 1.2;

    // vertical
    canvas.drawLine(
      Offset(pos.dx, 0),
      Offset(pos.dx, size.height),
      paint,
    );

    // horizontal
    canvas.drawLine(
      Offset(0, pos.dy),
      Offset(size.width, pos.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CrosshairPainter old) {
    return old.pos != pos;
  }
}
