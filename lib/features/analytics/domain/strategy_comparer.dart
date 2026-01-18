import 'trade_statistics.dart';

class StrategyComparer {
  final TradeStatistics a, b;

  StrategyComparer(this.a, this.b);

  String compare() {
    if (a.totalProfit > b.totalProfit) return "A أفضل";
    if (b.totalProfit > a.totalProfit) return "B أفضل";
    return "متعادلان";
  }
}
