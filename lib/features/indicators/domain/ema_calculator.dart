class EmaCalculator {
  final int period;
  late double _multiplier;
  double? _prevEma;

  EmaCalculator(this.period) {
    _multiplier = 2.0 / (period + 1);
  }

  double calculate(double price) {
    if (_prevEma == null) {
      _prevEma = price;
    } else {
      _prevEma = (price - _prevEma!) * _multiplier + _prevEma!;
    }
    return _prevEma!;
  }

  void reset() {
    _prevEma = null;
  }
}
