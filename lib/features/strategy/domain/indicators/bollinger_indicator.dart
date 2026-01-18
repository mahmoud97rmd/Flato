import 'indicator.dart';
import '../../../core/models/candle_entity.dart';
import 'dart:math';

class BollingerBand {
  final double upper;
  final double middle;
  final double lower;

  BollingerBand(this.upper, this.middle, this.lower);
}

class BollingerIndicator implements Indicator<BollingerBand> {
  final int period;
  final List<double> _closes = [];
  final List<BollingerBand> _series = [];

  BollingerIndicator(this.period);

  @override
  void addCandle(CandleEntity candle) {
    _closes.add(candle.close);
    if (_closes.length > period) _closes.removeAt(0);

    if (_closes.length == period) {
      final mean = _closes.reduce((a, b) => a + b) / period;
      final std = sqrt(_closes.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) / period);
      final upper = mean + 2 * std;
      final lower = mean - 2 * std;
      _series.add(BollingerBand(upper, mean, lower));
    }
  }

  @override
  BollingerBand get current => _series.isEmpty ? BollingerBand(0,0,0) : _series.last;

  @override
  List<BollingerBand> get series => List.unmodifiable(_series);
}
