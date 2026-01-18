import 'indicator_base.dart';

class EMAIndicator extends Indicator {
  final int period;
  EMAIndicator(this.period) : super("EMA\$period");

  @override
  List<double> compute(List<double> prices) {
    final List<double> result = [];
    if (prices.length < period) return result;
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
