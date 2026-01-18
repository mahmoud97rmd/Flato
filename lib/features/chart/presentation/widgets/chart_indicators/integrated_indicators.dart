import 'package:flutter/material.dart';
import '../../../domain/entities/candle.dart';
import 'dart:math';

/// ===============================
/// 1) BASE INDICATOR
/// ===============================
abstract class Indicator {
  final String name;
  Indicator(this.name);

  List<double> compute(List<double> prices);
  Color get color;
}

/// ===============================
/// 2) EMA INDICATOR
/// ===============================
class EMAIndicator extends Indicator {
  final int period;
  EMAIndicator(this.period) : super("EMA_$period");

  @override
  List<double> compute(List<double> prices) {
    if (prices.length < period) return [];

    final List<double> result = [];
    double k = 2 / (period + 1);

    double ema = prices.take(period).reduce((a, b) => a + b) / period;
    result.add(ema);

    for (int i = period; i < prices.length; i++) {
      ema = prices[i] * k + ema * (1 - k);
      result.add(ema);
    }
    return result;
  }

  @override
  Color get color => Colors.blue;
}

/// ===============================
/// 3) RSI INDICATOR
/// ===============================
class RSIIndicator extends Indicator {
  final int period;
  RSIIndicator(this.period) : super("RSI_$period");

  @override
  List<double> compute(List<double> prices) {
    if (prices.length < period + 1) return [];

    List<double> result = [];

    double gainSum = 0;
    double lossSum = 0;

    for (int i = 1; i <= period; i++) {
      double diff = prices[i] - prices[i - 1];
      if (diff >= 0) gainSum += diff;
      else lossSum -= diff;
    }

    double avgGain = gainSum / period;
    double avgLoss = lossSum / period;
    double rs = avgLoss == 0 ? 100 : avgGain / avgLoss;
    result.add(100 - (100 / (1 + rs)));

    for (int i = period + 1; i < prices.length; i++) {
      double diff = prices[i] - prices[i - 1];
      avgGain = ((avgGain * (period - 1)) + (diff > 0 ? diff : 0)) / period;
      avgLoss = ((avgLoss * (period - 1)) + (diff < 0 ? -diff : 0)) / period;
      rs = avgLoss == 0 ? 100 : avgGain / avgLoss;
      result.add(100 - (100 / (1 + rs)));
    }

    return result;
  }

  @override
  Color get color => Colors.orange;
}

/// ===============================
/// 4) MACD INDICATOR
/// ===============================
class MACDIndicator extends Indicator {
  final int shortPeriod;
  final int longPeriod;
  final int signalPeriod;

  MACDIndicator({
    this.shortPeriod = 12,
    this.longPeriod = 26,
    this.signalPeriod = 9,
  }) : super("MACD");

  List<double> _ema(List<double> prices, int period) {
    if (prices.length < period) return [];

    List<double> result = [];
    double k = 2 / (period + 1);

    double ema = prices.take(period).reduce((a, b) => a + b) / period;
    result.add(ema);

    for (int i = period; i < prices.length; i++) {
      ema = prices[i] * k + ema * (1 - k);
      result.add(ema);
    }
    return result;
  }

  @override
  List<double> compute(List<double> prices) {
    final emaShort = _ema(prices, shortPeriod);
    final emaLong = _ema(prices, longPeriod);

    int length = min(emaShort.length, emaLong.length);
    List<double> macd = [];

    for (int i = 0; i < length; i++) {
      macd.add(emaShort[i] - emaLong[i]);
    }

    final signal = _ema(macd, signalPeriod);

    int finalLen = min(macd.length, signal.length);
    List<double> histogram = [];

    for (int i = 0; i < finalLen; i++) {
      histogram.add(macd[i] - signal[i]);
    }

    return histogram;
  }

  @override
  Color get color => Colors.purple;
}

/// ===============================
/// 5) INDICATOR MANAGER (مُدمج)
/// ===============================
class IndicatorManager {
  final List<Indicator> _active = [];

  void add(Indicator i) {
    if (!_active.any((e) => e.name == i.name)) {
      _active.add(i);
    }
  }

  void remove(String name) {
    _active.removeWhere((e) => e.name == name);
  }

  void clear() {
    _active.clear();
  }

  List<Indicator> get all => List.unmodifiable(_active);
}

/// ===============================
/// 6) INDICATOR PAINTER (مُدمج)
/// ===============================
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
      final values = indicator.compute(closes);
      if (values.isEmpty) continue;

      final paint = Paint()
        ..color = indicator.color
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke;

      final path = Path();

      for (int i = 0; i < values.length; i++) {
        double x = i * barWidth;
        double y = (maxPrice - values[i]) / yRange * size.height;

        if (i == 0) path.moveTo(x, y);
        else path.lineTo(x, y);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant IndicatorPainter old) =>
      old.candles != candles || old.indicators != indicators;
}
