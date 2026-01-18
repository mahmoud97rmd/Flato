import '../../../market/domain/entities/candle.dart';

class RSIResult {
  final List<double> values;
  RSIResult(this.values);
}

class RSICalculator {
  static RSIResult calculate(List<CandleEntity> data, int period) {
    final values = <double>[];
    if (data.length <= period) return RSIResult(values);

    List<double> gains = [];
    List<double> losses = [];

    for (int i = 1; i < data.length; i++) {
      final change = data[i].close - data[i - 1].close;
      gains.add(change > 0 ? change : 0);
      losses.add(change < 0 ? -change : 0);
    }

    double avgGain = gains.take(period).reduce((a, b) => a + b) / period;
    double avgLoss = losses.take(period).reduce((a, b) => a + b) / period;
    values.add(100 - (100 / (1 + (avgGain / avgLoss))));

    for (int i = period; i < gains.length; i++) {
      avgGain = ((avgGain * (period - 1)) + gains[i]) / period;
      avgLoss = ((avgLoss * (period - 1)) + losses[i]) / period;

      final rs = avgGain / (avgLoss == 0 ? 1 : avgLoss);
      final rsi = 100 - (100 / (1 + rs));
      values.add(rsi);
    }

    return RSIResult(values);
  }
}
