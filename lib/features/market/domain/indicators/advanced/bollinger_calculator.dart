import '../entities/candle.dart';
import 'dart:math';

class BollingerResult {
  final List<double> middleBand;
  final List<double> upperBand;
  final List<double> lowerBand;

  BollingerResult({
    required this.middleBand,
    required this.upperBand,
    required this.lowerBand,
  });
}

class BollingerCalculator {
  static BollingerResult calculate(
    List<CandleEntity> data, {
    int period = 20,
    double stdDevMultiplier = 2.0,
  }) {
    List<double> closes = data.map((c) => c.close).toList();

    List<double> middle = [];
    List<double> upper = [];
    List<double> lower = [];

    for (int i = 0; i < closes.length; i++) {
      if (i + 1 >= period) {
        List<double> window = closes.sublist(i + 1 - period, i + 1);
        double mean = window.reduce((a, b) => a + b) / period;
        double sumSq = window.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b);
        double stdDev = sqrt(sumSq / period);

        middle.add(mean);
        upper.add(mean + stdDevMultiplier * stdDev);
        lower.add(mean - stdDevMultiplier * stdDev);
      } else {
        middle.add(0);
        upper.add(0);
        lower.add(0);
      }
    }
    return BollingerResult(
      middleBand: middle,
      upperBand: upper,
      lowerBand: lower,
    );
  }
}
