import 'package:flutter/material.dart';
import '../../../market/domain/entities/candle.dart';
import 'chart_utils/chart_mapper.dart';
import '../../../market/domain/chart/x_axis_range.dart';

class CandlesPainter extends CustomPainter {
  final List<CandleEntity> candles;
  final XAxisRange visibleRange;

  CandlesPainter({required this.candles, required this.visibleRange});

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    double minPrice = candles.map((c) => c.low).reduce((a, b) => a < b ? a : b);
    double maxPrice = candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);

    final paintBull = Paint()..color = Colors.green;
    final paintBear = Paint()..color = Colors.red;

    for (var c in candles) {
      if (!visibleRange.contains(c.time)) continue;

      final x = timeToPx(c.time, visibleRange, size.width);
      final yHigh = priceToPx(c.high, minPrice, maxPrice, size.height);
      final yLow = priceToPx(c.low, minPrice, maxPrice, size.height);
      final yOpen = priceToPx(c.open, minPrice, maxPrice, size.height);
      final yClose = priceToPx(c.close, minPrice, maxPrice, size.height);

      final isBull = c.close >= c.open;
      final paint = isBull ? paintBull : paintBear;

      // Wick
      canvas.drawLine(Offset(x, yHigh), Offset(x, yLow), paint);

      // Body
      final bodyTop = isBull ? yClose : yOpen;
      final bodyBottom = isBull ? yOpen : yClose;
      canvas.drawRect(Rect.fromLTRB(x - 2, bodyTop, x + 2, bodyBottom), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CandlesPainter old) {
    return old.visibleRange != visibleRange || old.candles != candles;
  }
}
