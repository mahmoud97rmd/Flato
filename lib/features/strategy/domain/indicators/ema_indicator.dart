import 'indicator.dart';
import '../../../core/models/candle_entity.dart';

class EMAIndicator implements Indicator<double> {
  final int period;
  double? _ema;
  final List<double> _series = [];

  EMAIndicator(this.period);

  double get _multiplier => 2.0 / (period + 1);

  @override
  void addCandle(CandleEntity candle) {
    final price = candle.close;

    _ema = _ema == null ? price : (price - _ema!) * _multiplier + _ema!;
    _series.add(_ema!);
  }

  @override
  double get current => _ema ?? 0;

  @override
  List<double> get series => List.unmodifiable(_series);
}
