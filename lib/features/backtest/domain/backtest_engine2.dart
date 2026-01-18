import '../../../core/models/candle_entity.dart';

class BacktestEngine2 {
  final List<CandleEntity> history;
  final StrategyEngine strategy;

  BacktestEngine2(this.history, this.strategy);

  void run() {
    Map<String, double> lastIndicators = {};

    for (int i = 0; i < history.length; i++) {
      final candle = history[i];
      // تحديث المؤشرات أولا
      lastIndicators = calculateIndicators(history.sublist(0, i + 1));
      final signals = strategy.evaluateSignals(lastIndicators);

      // تنفيذ الإشارات بعد التأكد من الانتهاء من التحديث
      for (final s in signals) {
        executeSignal(s, candle);
      }
    }
  }
}
