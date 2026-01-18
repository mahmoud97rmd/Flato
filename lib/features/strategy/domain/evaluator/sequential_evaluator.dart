import '../../../core/models/candle_entity.dart';
import '../ast/expr_node.dart';
import '../indicators/ema.dart';

enum Signal { BUY, SELL, NONE }

class SequentialEvaluator {
  final EMAIndicator emaFast;
  final EMAIndicator emaSlow;
  final ExprNode root;

  SequentialEvaluator({
    required this.emaFast,
    required this.emaSlow,
    required this.root,
  });

  /// تقييم الاستراتيجية عبر كل الشموع
  List<Signal> evaluateSeries(List<CandleEntity> history) {
    List<Signal> signals = [];

    for (int i = 0; i < history.length; i++) {
      final candle = history[i];

      // تحديث المؤشرات أولًا
      emaFast.addCandle(candle);
      emaSlow.addCandle(candle);

      // تقييم AST
      bool condition = root.evaluate(candle, i);

      if (condition) {
        signals.add(Signal.BUY);
      } else {
        signals.add(Signal.NONE);
      }
    }

    return signals;
  }
}
