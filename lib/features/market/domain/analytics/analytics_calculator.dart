class AnalyticsResult {
  final double netProfit;
  final double winRate;
  final double sharpRatio;
  final double expectancy;
  final int totalTrades;
  final int wins;
  final int losses;

  AnalyticsResult({
    required this.netProfit,
    required this.winRate,
    required this.sharpRatio,
    required this.expectancy,
    required this.totalTrades,
    required this.wins,
    required this.losses,
  });
}

class AnalyticsCalculator {
  static AnalyticsResult calculate(List<double> profits) {
    final n = profits.length;
    if (n == 0) {
      return AnalyticsResult(
        netProfit: 0,
        winRate: 0,
        sharpRatio: 0,
        expectancy: 0,
        totalTrades: 0,
        wins: 0,
        losses: 0,
      );
    }

    double netProfit = profits.reduce((a, b) => a + b);

    int wins = profits.where((p) => p > 0).length;
    int losses = profits.where((p) => p <= 0).length;

    double winRate = wins / n * 100;

    double avgProfit = netProfit / n;

    double variance = profits
        .map((p) => (p - avgProfit) * (p - avgProfit))
        .reduce((a, b) => a + b) / n;
    double stdDev = variance.sqrt();

    double sharpRatio = stdDev == 0 ? 0 : avgProfit / stdDev;

    double expectancy = ((wins / n) * (profits.where((p) => p > 0).reduce((a, b) => a + b) / wins)) -
        ((losses / n) * (profits.where((p) => p <= 0).reduce((a, b) => a + b) / (losses == 0 ? 1 : losses)));

    return AnalyticsResult(
      netProfit: netProfit,
      winRate: winRate,
      sharpRatio: sharpRatio,
      expectancy: expectancy,
      totalTrades: n,
      wins: wins,
      losses: losses,
    );
  }
}
