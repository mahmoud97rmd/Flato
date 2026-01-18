import '../../../market/domain/entities/candle.dart';
import 'ema_calculator.dart';

class MACDResult {
  final List<double> macd;
  final List<double> signal;
  final List<double> histogram;

  MACDResult({required this.macd, required this.signal, required this.histogram});
}

class MACDCalculator {
  static MACDResult calculate(List<CandleEntity> data, {int fast = 12, int slow = 26, int signalPeriod = 9}) {
    final close = data.map((c) => c.close).toList();
    final fastEma = EMACalculator.calculate(data, fast).values;
    final slowEma = EMACalculator.calculate(data, slow).values;

    final macdLine = List<double>.generate(close.length, (i) {
      if (i < slow - 1) return 0.0;
      return fastEma[i] - slowEma[i];
    });

    final signalLine = <double>[];
    double? prevSignal;

    for (int i = 0; i < macdLine.length; i++) {
      if (i < slow - 1 + signalPeriod - 1) {
        signalLine.add(0.0);
      } else if (i == slow - 1 + signalPeriod - 1) {
        final sum = macdLine.sublist(slow - 1, slow - 1 + signalPeriod).fold(0.0, (a, b) => a + b);
        prevSignal = sum / signalPeriod;
        signalLine.add(prevSignal);
      } else {
        final next = ((macdLine[i] - prevSignal!) * (2 / (signalPeriod + 1))) + prevSignal;
        prevSignal = next;
        signalLine.add(next);
      }
    }

    final hist = List<double>.generate(close.length, (i) => macdLine[i] - signalLine[i]);

    return MACDResult(macd: macdLine, signal: signalLine, histogram: hist);
  }
}
