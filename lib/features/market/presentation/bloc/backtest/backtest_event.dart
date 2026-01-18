abstract class BacktestEvent {}

class RunBacktest extends BacktestEvent {
  final List<dynamic> history; // List<CandleEntity>
  final String strategyId;      // معرف الاستراتيجية (سيتم ترجمته لاحقًا)
  final double takeProfit;
  final double stopLoss;

  RunBacktest({
    required this.history,
    required this.strategyId,
    this.takeProfit = 0,
    this.stopLoss = 0,
  });
}

class CancelBacktest extends BacktestEvent {}
