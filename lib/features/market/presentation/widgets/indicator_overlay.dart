import 'package:flutter/material.dart';

class IndicatorOverlay extends StatelessWidget {
  final List<List<Offset>> indicatorLines;

  IndicatorOverlay({required this.indicatorLines});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _IndicatorPainter(indicatorLines),
      child: Container(),
    );
  }
}

class _IndicatorPainter extends CustomPainter {
  final List<List<Offset>> indicatorLines;

  _IndicatorPainter(this.indicatorLines);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (var series in indicatorLines) {
      paint.color = Colors.green;
      canvas.drawPoints(PointMode.polygon, series, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _IndicatorPainter old) =>
      old.indicatorLines != indicatorLines;
}
