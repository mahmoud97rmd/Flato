import '../../../market/domain/entities/candle.dart';
import 'dart:math';

class BollingerResult {
  final List<double> middle;
  final List<double> upper;
  final List<double> lower;

  BollingerResult({required this.middle, required this.upper, required this.lower});
}

class BollingerCalculator {
  static BollingerResult calculate(List<CandleEntity> data, int period, double mult) {
    final closes = data.map((c) => c.close).toList();
    final middle = <double>[];
    final upper = <double>[];
    final lower = <double>[];

    for (int i = 0; i < closes.length; i++) {
      if (i + 1 >= period) {
        final window = closes.sublist(i + 1 - period, i + 1);
        final mean = window.reduce((a, b) => a + b) / period;
        final variance = window.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) / period;
        final stdDev = sqrt(variance);

        middle.add(mean);
        upper.add(mean + (stdDev * mult));
        lower.add(mean - (stdDev * mult));
      } else {
        middle.add(0.0);
        upper.add(0.0);
        lower.add(0.0);
      }
    }

    return BollingerResult(middle: middle, upper: upper, lower: lower);
  }
}
