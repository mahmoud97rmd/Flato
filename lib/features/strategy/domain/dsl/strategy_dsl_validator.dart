class StrategyDslValidator {
  static bool isValid(List<String> tokens) {
    if (tokens.isEmpty) return false;
    final ops = ['>', '<', '>=', '<=', 'AND', 'OR'];
    // بسيط جدًا: لا يمكن أن يبدأ بـ Operator أو ينتهي به
    if (ops.contains(tokens.first) || ops.contains(tokens.last)) return false;
    return true;
  }
}
