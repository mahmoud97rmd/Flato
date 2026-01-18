import 'strategy_dsl_validator.dart';
import 'strategy_dsl_safety.dart';

bool safeEval(String expr) {
  final tokens = expr.split(RegExp(r"\s+"));
  if (!StrategyDslValidator.isValid(tokens)) return false;
  if (!StrategyDslSafety.hasEnoughTokens(tokens)) return false;
  return true;
}
