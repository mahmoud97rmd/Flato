import '../../domain/entities/candle.dart';
import 'dart:math';

class StochasticResult {
  final List<double> kValues;
  final List<double> dValues;
  final int period;
  final int smoothK;
  final int smoothD;

  StochasticResult({
    required this.kValues,
    required this.dValues,
    required this.period,
    required this.smoothK,
    required this.smoothD,
  });
}

class StochasticCalculator {
  static StochasticResult calculate({
    required List<CandleEntity> data,
    required int period,
    required int smoothK,
    required int smoothD,
  }) {
    List<double> k = [];
    List<double> d = [];

    for (int i = 0; i < data.length; i++) {
      if (i < period) {
        k.add(0);
        d.add(0);
        continue;
      }

      double highestHigh = data
          .sublist(i - period + 1, i + 1)
          .map((c) => c.high)
          .reduce(max);

      double lowestLow = data
          .sublist(i - period + 1, i + 1)
          .map((c) => c.low)
          .reduce(min);

      double currentClose = data[i].close;

      double rawK = ((currentClose - lowestLow) / (highestHigh - lowestLow)) *
          100;

      k.add(rawK);

      if (i >= period + smoothK - 1) {
        double avgK = k.sublist(i - smoothK + 1, i + 1).reduce((a, b) => a + b) /
            smoothK;
        if (d.length >= smoothD) {
          double avgD =
              d.sublist(i - smoothD + 1, i + 1).reduce((a, b) => a + b) /
                  smoothD;
          d.add(avgD);
        } else {
          d.add(avgK);
        }
      } else {
        d.add(0);
      }
    }

    return StochasticResult(
      kValues: k,
      dValues: d,
      period: period,
      smoothK: smoothK,
      smoothD: smoothD,
    );
  }
}
