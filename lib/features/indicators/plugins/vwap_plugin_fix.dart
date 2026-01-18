Map<String, double> compute(List candles) {
  double cumulPV = 0, cumulVol = 0;
  for (var c in candles) {
    final typical = (c.high + c.low + c.close) / 3;
    cumulPV += typical * c.volume;
    cumulVol += c.volume;
  }
  final vwap = cumulVol == 0 ? 0.0 : cumulPV / cumulVol;
  return {'VWAP': vwap};
}
