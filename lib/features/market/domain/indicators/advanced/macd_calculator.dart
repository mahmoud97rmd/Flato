import '../entities/candle.dart';
import 'package:collection/collection.dart';

class MacdResult {
  final List<double> macdLine;
  final List<double> signalLine;
  final List<double> histogram;

  MacdResult({
    required this.macdLine,
    required this.signalLine,
    required this.histogram,
  });
}

class MacdCalculator {
  static MacdResult calculate(
    List<CandleEntity> data, {
    int fastPeriod = 12,
    int slowPeriod = 26,
    int signalPeriod = 9,
  }) {
    List<double> closePrices = data.map((c) => c.close).toList();

    List<double> emaFast = _ema(closePrices, fastPeriod);
    List<double> emaSlow = _ema(closePrices, slowPeriod);

    List<double> macdLine = List.generate(closePrices.length, (i) {
      return emaFast[i] - emaSlow[i];
    });

    List<double> signalLine = _ema(macdLine, signalPeriod);

    List<double> histogram = List.generate(closePrices.length, (i) {
      return macdLine[i] - signalLine[i];
    });

    return MacdResult(
      macdLine: macdLine,
      signalLine: signalLine,
      histogram: histogram,
    );
  }

  static List<double> _ema(List<double> data, int period) {
    List<double> kList = [];
    double multiplier = 2 / (period + 1);

    List<double> ema = [];
    ema.add(data.take(period).reduce((a, b) => a + b) / period);

    for (int i = period; i < data.length; i++) {
      ema.add((data[i] - ema.last) * multiplier + ema.last);
    }

    return ema;
  }
}
