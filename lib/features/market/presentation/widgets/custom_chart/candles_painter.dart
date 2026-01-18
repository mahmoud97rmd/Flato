import 'package:flutter/material.dart';
import '../../../domain/entities/candle.dart';

class CandlesPainter extends CustomPainter {
  final List<CandleEntity> candles;
  final double candleWidth;

  CandlesPainter({
    required this.candles,
    this.candleWidth = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final paintRise = Paint()..color = Colors.green;
    final paintFall = Paint()..color = Colors.red;
    final paintLine = Paint()..color = Colors.black;

    // احسب الأسعار العليا والدنيا ليتناسب الرسم
    final highs = candles.map((c) => c.high).toList();
    final lows = candles.map((c) => c.low).toList();

    final maxPrice = highs.reduce((a, b) => a > b ? a : b);
    final minPrice = lows.reduce((a, b) => a < b ? a : b);

    final priceRange = maxPrice - minPrice;

    final count = candles.length;
    final spacing = candleWidth + 2.0;
    final chartWidth = count * spacing;

    for (int i = 0; i < count; i++) {
      final c = candles[i];

      final x = i * spacing;
      final highY = size.height - ((c.high - minPrice) / priceRange) * size.height;
      final lowY = size.height - ((c.low - minPrice) / priceRange) * size.height;
      final openY = size.height - ((c.open - minPrice) / priceRange) * size.height;
      final closeY = size.height - ((c.close - minPrice) / priceRange) * size.height;

      final isRise = c.close >= c.open;
      final paint = isRise ? paintRise : paintFall;

      // خطوط High-Low
      canvas.drawLine(
        Offset(x + candleWidth / 2, highY),
        Offset(x + candleWidth / 2, lowY),
        paintLine,
      );

      // مستطيل Open-Close
      final rect = Rect.fromLTRB(
        x,
        openY,
        x + candleWidth,
        closeY,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CandlesPainter old) =>
      old.candles != candles;
}
