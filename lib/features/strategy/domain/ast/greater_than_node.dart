import 'expr_node.dart';
import '../indicators/indicator.dart';
import '../../../core/models/candle_entity.dart';

class GreaterThanNode extends ExprNode {
  final Indicator<double> left;
  final Indicator<double> right;

  GreaterThanNode(this.left, this.right);

  @override
  bool evaluate(CandleEntity candle, int index) {
    return left.current > right.current;
  }
}
