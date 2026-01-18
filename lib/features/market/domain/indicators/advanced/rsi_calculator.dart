import '../entities/candle.dart';

class RsiResult {
  final List<double> values;
  RsiResult(this.values);
}

class RsiCalculator {
  static RsiResult calculate(List<CandleEntity> data, {int period = 14}) {
    final List<double> deltas = [];
    for (int i = 1; i < data.length; i++) {
      deltas.add(data[i].close - data[i - 1].close);
    }

    List<double> gains = [];
    List<double> losses = [];

    for (var d in deltas) {
      gains.add(d > 0 ? d : 0);
      losses.add(d < 0 ? -d : 0);
    }

    List<double> avgGain = [];
    List<double> avgLoss = [];

    double sumGain = gains.take(period).reduce((a, b) => a + b);
    double sumLoss = losses.take(period).reduce((a, b) => a + b);

    avgGain.add(sumGain / period);
    avgLoss.add(sumLoss / period);

    for (int i = period; i < gains.length; i++) {
      double gain = gains[i];
      double loss = losses[i];

      avgGain.add((avgGain.last * (period - 1) + gain) / period);
      avgLoss.add((avgLoss.last * (period - 1) + loss) / period);
    }

    List<double> rsi = List.filled(data.length, 0.0);
    for (int i = period; i < avgGain.length + period; i++) {
      double rs = avgGain[i - period] / (avgLoss[i - period] == 0 ? 1 : avgLoss[i - period]);
      rsi[i] = 100 - (100 / (1 + rs));
    }

    return RsiResult(rsi);
  }
}
