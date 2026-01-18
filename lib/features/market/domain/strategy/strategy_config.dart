class StrategyConfig {
  final int emaShort;
  final int emaLong;
  final int stochPeriod;
  final int stochSmoothK;
  final int stochSmoothD;
  final double stopLossPct;
  final double takeProfitPct;
  final double minSignalIntervalSeconds;

  StrategyConfig({
    required this.emaShort,
    required this.emaLong,
    required this.stochPeriod,
    required this.stochSmoothK,
    required this.stochSmoothD,
    required this.stopLossPct,
    required this.takeProfitPct,
    required this.minSignalIntervalSeconds,
  });
}
