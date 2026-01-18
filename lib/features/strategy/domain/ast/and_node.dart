import 'expr_node.dart';
import '../../../core/models/candle_entity.dart';

class AndNode extends ExprNode {
  final ExprNode a;
  final ExprNode b;

  AndNode(this.a, this.b);

  @override
  bool evaluate(CandleEntity candle, int index) {
    return a.evaluate(candle, index) && b.evaluate(candle, index);
  }
}
