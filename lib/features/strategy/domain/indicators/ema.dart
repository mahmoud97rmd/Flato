import '../../../core/models/candle_entity.dart';
import 'indicator.dart';
import 'dart:math';

class EMAIndicator implements Indicator<double> {
  final int period;
  double? _prevEma;
  final List<double> _series = [];

  EMAIndicator(this.period);

  double get _multiplier => 2.0 / (period + 1);

  @override
  void addCandle(CandleEntity candle) {
    final price = candle.close;

    if (_prevEma == null) {
      _prevEma = price; // أول قيمة
    } else {
      _prevEma = (price - _prevEma!) * _multiplier + _prevEma!;
    }

    _series.add(_prevEma!);
  }

  @override
  double get current => _prevEma ?? 0.0;

  @override
  List<double> get series => List.unmodifiable(_series);
}
