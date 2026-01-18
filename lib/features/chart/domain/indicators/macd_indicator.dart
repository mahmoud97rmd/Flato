import 'indicator_base.dart';
import 'ema_indicator.dart';

class MACDIndicator extends Indicator {
  final int shortPeriod;
  final int longPeriod;
  final int signalPeriod;

  MACDIndicator({
    this.shortPeriod = 12,
    this.longPeriod = 26,
    this.signalPeriod = 9,
  }) : super("MACD");

  @override
  List<double> compute(List<double> prices) {
    final emaShort = EMAIndicator(shortPeriod).compute(prices);
    final emaLong = EMAIndicator(longPeriod).compute(prices);
    final List<double> macd = [];

    int length = emaShort.length < emaLong.length ? emaShort.length : emaLong.length;
    for (int i = 0; i < length; i++) {
      macd.add(emaShort[i] - emaLong[i]);
    }

    final signal = EMAIndicator(signalPeriod).compute(macd);
    return macd.mapIndexed((i, v) => v - signal[i]).toList();
  }

  @override
  Color get color => Colors.purple;
}
