import 'package:meta/meta.dart';
import '../../../core/models/candle_entity.dart';
import '../strategy/domain/evaluator/sequential_evaluator.dart';
import 'backtest_models.dart';
import 'backtest_result.dart';

class BacktestEngine {
  final List<CandleEntity> history;
  final SequentialEvaluator evaluator;
  final double initialBalance;
  final double takeProfit; // نسبة الربح (مثال: 0.02 = 2%)
  final double stopLoss;   // نسبة الخسارة (مثال: 0.01 = 1%)

  BacktestEngine({
    required this.history,
    required this.evaluator,
    this.initialBalance = 10000,
    this.takeProfit = 0,
    this.stopLoss = 0,
  });

  BacktestResult run() {
    double balance = initialBalance;
    double equity = initialBalance;
    List<double> equityCurve = [];
    List<double> balanceCurve = [];
    List<dynamic> trades = [];

    Position? currentPosition;

    for (int i = 0; i < history.length; i++) {
      final candle = history[i];

      // --- 1) تحديث المؤشرات وإشارات الاستراتيجية ---
      evaluator.emaFast.addCandle(candle);
      evaluator.emaSlow.addCandle(candle);
      bool signal = evaluator.root.evaluate(candle, i);

      // --- 2) إدارة الصفقات المفتوحة ---
      if (currentPosition != null) {
        final price = candle.close;

        final profit = (currentPosition.side == OrderSide.buy)
            ? (price - currentPosition.entryPrice) * currentPosition.size
            : (currentPosition.entryPrice - price) * currentPosition.size;

        equity = balance + profit;

        // --- تحقق TP/SL إذا كانت > 0 ---
        if (takeProfit > 0 && profit >= currentPosition.entryPrice * takeProfit) {
          currentPosition.exitPrice = price;
          currentPosition.exitTime = candle.timeUtc;
          trades.add(currentPosition);
          balance += profit;
          currentPosition = null;
        } else if (stopLoss > 0 &&
            profit <= -currentPosition.entryPrice * stopLoss) {
          currentPosition.exitPrice = price;
          currentPosition.exitTime = candle.timeUtc;
          trades.add(currentPosition);
          balance += profit;
          currentPosition = null;
        }
      }

      // --- 3) تقييم الدخول/الخروج الجديد إذا لم يكن هناك صفقة حالية ---
      if (currentPosition == null && signal) {
        currentPosition = Position(
          side: OrderSide.buy,
          entryPrice: candle.close,
          entryTime: candle.timeUtc,
          size: 1.0,
        );
      }

      equityCurve.add(equity);
      balanceCurve.add(balance);
    }

    // --- 4) حساب الإحصاءات ---
    final netProfit = equity - initialBalance;
    final closedTrades = trades.where((t) => t.exitPrice != null).toList();
    final wins = closedTrades.where((p) => p.profit > 0).length;
    final totalTrades = closedTrades.length;
    final winRate = totalTrades > 0 ? wins / totalTrades : 0.0;

    double peak = equityCurve.isNotEmpty ? equityCurve.first : initialBalance;
    double maxDrawdown = 0;
    for (var val in equityCurve) {
      if (val > peak) peak = val;
      final dd = (peak - val) / peak;
      if (dd > maxDrawdown) maxDrawdown = dd;
    }

    return BacktestResult(
      equityCurve: equityCurve,
      balanceCurve: balanceCurve,
      trades: trades,
      netProfit: netProfit,
      winRate: winRate,
      maxDrawdown: maxDrawdown,
    );
  }
}
