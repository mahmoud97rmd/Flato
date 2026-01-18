class HedgeManager {
  bool shouldHedge(double exposure, double threshold) {
    return exposure.abs() > threshold;
  }
}
