import 'indicator_base.dart';

class RSIIndicator extends Indicator {
  final int period;
  RSIIndicator(this.period) : super("RSI\$period");

  @override
  List<double> compute(List<double> prices) {
    final List<double> result = [];
    if (prices.length < period + 1) return result;

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
