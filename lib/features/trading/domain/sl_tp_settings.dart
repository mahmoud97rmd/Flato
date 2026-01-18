class SLTPSettings {
  double stopLoss = 0;
  double takeProfit = 0;

  void update(double sl, double tp) {
    stopLoss = sl;
    takeProfit = tp;
  }
}
