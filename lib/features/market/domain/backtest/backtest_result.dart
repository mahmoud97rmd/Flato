class BacktestResult {
  final List<double> equityCurve;
  final List<double> balanceCurve;
  final List<dynamic> trades; // يمكن ترقية النوع لاحقًا
  final double netProfit;
  final double winRate;
  final double maxDrawdown;

  BacktestResult({
    required this.equityCurve,
    required this.balanceCurve,
    required this.trades,
    required this.netProfit,
    required this.winRate,
    required this.maxDrawdown,
  });
}
