import 'expr_node.dart';
import '../indicators/indicator.dart';
import '../../../core/models/candle_entity.dart';

class CrossUpNode extends ExprNode {
  final Indicator<double> fast;
  final Indicator<double> slow;
  double? _prevFast;
  double? _prevSlow;

  CrossUpNode(this.fast, this.slow);

  @override
  bool evaluate(CandleEntity candle, int index) {
    final currFast = fast.current;
    final currSlow = slow.current;

    bool crossed = false;

    if (_prevFast != null && _prevSlow != null) {
      crossed = (_prevFast! <= _prevSlow!) && (currFast > currSlow);
    }

    _prevFast = currFast;
    _prevSlow = currSlow;

    return crossed;
  }
}
