import '../../../market/domain/entities/candle.dart';

class EMAResult {
  final List<double> values;
  EMAResult(this.values);
}

class EMACalculator {
  static EMAResult calculate(List<CandleEntity> data, int period) {
    final values = <double>[];
    if (data.isEmpty || period <= 0) return EMAResult(values);

    final k = 2 / (period + 1);
    double? prevEma;

    for (int i = 0; i < data.length; i++) {
      final price = data[i].close;
      if (i + 1 < period) {
        // Not enough data yet — push 0 or null
        values.add(0.0);
      } else if (i + 1 == period) {
        // First EMA = simple average
        final sum = data.sublist(0, period).fold(0.0, (p, c) => p + c.close);
        prevEma = sum / period;
        values.add(prevEma);
      } else {
        final ema = (price - prevEma!) * k + prevEma;
        prevEma = ema;
        values.add(ema);
      }
    }

    return EMAResult(values);
  }
}
