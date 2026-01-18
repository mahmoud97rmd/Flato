import 'package:flutter/material.dart';
import '../../../domain/entities/candle.dart';
import '../../../../../features/chart/domain/indicators/indicator_base.dart';
import 'dart:math';

class IndicatorPainter extends CustomPainter {
  final List<Candle> candles;
  final List<Indicator> indicators;

  IndicatorPainter(this.candles, this.indicators);

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty || indicators.isEmpty) return;

    List<double> closes = candles.map((e) => e.close).toList();
    final maxPrice = candles.map((c) => c.high).reduce(max);
    final minPrice = candles.map((c) => c.low).reduce(min);
    final yRange = maxPrice - minPrice;

    double barWidth = size.width / candles.length;

    for (var indicator in indicators) {
      final vals = indicator.compute(closes);
      if (vals.isEmpty) continue;

      final paint = Paint()
        ..color = indicator.color
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke;

      final path = Path();

      for (int j = 0; j < vals.length; j++) {
        double vx = j * barWidth;
        double vy = (maxPrice - vals[j]) / yRange * size.height;
        if (j == 0) path.moveTo(vx, vy);
        else path.lineTo(vx, vy);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant IndicatorPainter old) =>
      old.candles != candles || old.indicators != indicators;
}
