import 'package:flutter/material.dart';

class MarkerPainter extends CustomPainter {
  final List<Offset> buyPoints;
  final List<Offset> sellPoints;

  MarkerPainter({required this.buyPoints, required this.sellPoints});

  @override
  void paint(Canvas canvas, Size size) {
    final paintBuy = Paint()..color = Colors.greenAccent;
    final paintSell = Paint()..color = Colors.redAccent;

    for (var p in buyPoints) {
      canvas.drawCircle(p, 6, paintBuy);
    }
    for (var p in sellPoints) {
      canvas.drawCircle(p, 6, paintSell);
    }
  }

  @override
  bool shouldRepaint(covariant MarkerPainter old) => true;
}
