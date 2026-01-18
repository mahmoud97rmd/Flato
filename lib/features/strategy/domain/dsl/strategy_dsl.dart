class StrategyDSLParser {
  /// مثال: "EMA50 > EMA150 AND RSI14 < 30"
  static List<String> tokenize(String expr) =>
      expr.split(RegExp(r"\s+")).toList();
}
