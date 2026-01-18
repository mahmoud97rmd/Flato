import 'indicator.dart';
import '../../../core/models/candle_entity.dart';

class RSIIndicator implements Indicator<double> {
  final int period;
  final List<CandleEntity> _history = [];
  final List<double> _series = [];
  double? _avgGain;
  double? _avgLoss;

  RSIIndicator(this.period);

  @override
  void addCandle(CandleEntity candle) {
    if (_history.isNotEmpty) {
      final prev = _history.last;
      final change = candle.close - prev.close;
      final gain = change > 0 ? change : 0;
      final loss = change < 0 ? -change : 0;

      if (_avgGain == null) {
        _avgGain = gain;
        _avgLoss = loss;
      } else {
        _avgGain = (_avgGain! * (period - 1) + gain) / period;
        _avgLoss = (_avgLoss! * (period - 1) + loss) / period;
      }

      if (_avgLoss == 0) {
        _series.add(100.0);
      } else {
        final rs = _avgGain! / _avgLoss!;
        _series.add(100 - (100 / (1 + rs)));
      }
    }

    _history.add(candle);
  }

  @override
  double get current => _series.isEmpty ? 0 : _series.last;

  @override
  List<double> get series => List.unmodifiable(_series);
}
