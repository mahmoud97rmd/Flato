import 'ast.dart';
import '../../../market/domain/entities/candle.dart';
import '../../strategy_script/domain/ast.dart';

typedef IndicatorFunc = List<double> Function(List<CandleEntity>, int);

class ScriptInterpreter {
  final List<ASTNode> ast;
  final Map<String, IndicatorFunc> indicatorLibrary;

  ScriptInterpreter(this.ast, this.indicatorLibrary);

  bool evaluate(List<CandleEntity> history) {
    for (var node in ast) {
      if (node is IfStatement) {
        final cond = _evalExpression(node.condition, history);
        if (cond) {
          if (node.action.type.toUpperCase() == 'BUY') return true;
        }
      }
    }
    return false;
  }

  dynamic _evalExpression(Expression expr, List<CandleEntity> history) {
    if (expr is FunctionCall) {
      final name = expr.name.toUpperCase();
      final args = expr.args.map((e) => _evalExpression(e, history)).toList();

      if (indicatorLibrary.containsKey(name)) {
        return indicatorLibrary[name]!(history, args[1].toInt());
      }
    }
    return null;
  }
}
