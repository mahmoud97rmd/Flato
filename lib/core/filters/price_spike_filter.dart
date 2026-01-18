class PriceSpikeFilter {
  static bool isSpike(double prev, double curr, double thresholdPct) {
    final diff = (curr - prev).abs();
    final pct = (diff / prev) * 100.0;
    return pct > thresholdPct;
  }
}
