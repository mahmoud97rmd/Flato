import 'package:flutter/material.dart';
import '../../../domain/entities/candle.dart';

class CandlestickChartCanvas extends StatelessWidget {
  final List<Candle> candles;
  final double barSpacing;

  const CandlestickChartCanvas({
    required this.candles,
    this.barSpacing = 6.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _CandlePainter(candles: candles, barSpacing: barSpacing),
    );
  }
}

class _CandlePainter extends CustomPainter {
  final List<Candle> candles;
  final double barSpacing;

  _CandlePainter({
    required this.candles,
    required this.barSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final paint = Paint()..strokeWidth = 1.2;
    final maxPrice = candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);
    final minPrice = candles.map((c) => c.low).reduce((a, b) => a < b ? a : b);

    final yRange = maxPrice - minPrice;
    if (yRange == 0) return;

    final barWidth = barSpacing;

    for (int i = 0; i < candles.length; i++) {
      final c = candles[i];
      final dx = i * barWidth;

      final openY = (maxPrice - c.open) / yRange * size.height;
      final closeY = (maxPrice - c.close) / yRange * size.height;
      final highY = (maxPrice - c.high) / yRange * size.height;
      final lowY = (maxPrice - c.low) / yRange * size.height;

      paint.color = c.close >= c.open ? Colors.green : Colors.red;

      // wick
      canvas.drawLine(
        Offset(dx + barWidth / 2, highY),
        Offset(dx + barWidth / 2, lowY),
        paint,
      );

      // body
      final rect = Rect.fromLTRB(
        dx,
        openY,
        dx + barWidth,
        closeY,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CandlePainter old) {
    return old.candles != candles;
  }
}
