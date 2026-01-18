import '../indicators/ema.dart';
import '../ast/greater_than_node.dart';
import '../ast/and_node.dart';
import '../ast/cross_up_node.dart';
import 'sequential_evaluator.dart';

SequentialEvaluator buildExampleStrategy() {
  final ema10 = EMAIndicator(10);
  final ema20 = EMAIndicator(20);

  final greater = GreaterThanNode(ema10, ema20);
  final cross = CrossUpNode(ema10, ema20);

  final root = AndNode(greater, cross);

  return SequentialEvaluator(
    emaFast: ema10,
    emaSlow: ema20,
    root: root,
  );
}
