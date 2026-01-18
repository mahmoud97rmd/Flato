class RsiCalculator {
  final int period;
  final List<double> _gains = [];
  final List<double> _losses = [];

  RsiCalculator(this.period);

  double? calculate(double prevClose, double close) {
    final diff = close - prevClose;
    final gain = diff > 0 ? diff : 0;
    final loss = diff < 0 ? -diff : 0;

    _gains.add(gain);
    _losses.add(loss);

    if (_gains.length > period) {
      _gains.removeAt(0);
      _losses.removeAt(0);
    }

    if (_gains.length < period) return null;

    final avgGain =
        _gains.reduce((a, b) => a + b) / _gains.length;
    final avgLoss =
        _losses.reduce((a, b) => a + b) / _losses.length;

    final rs = avgLoss == 0 ? 100 : avgGain / avgLoss;
    return 100 - (100 / (1 + rs));
  }

  void reset() {
    _gains.clear();
    _losses.clear();
  }
}
