class StrategyModel {
  final List<String> requiredSignals;
  final String action; // BUY / SELL

  StrategyModel({
    required this.requiredSignals,
    required this.action,
  });

  bool canTrigger(List<String> activeSignals) {
    return requiredSignals.every((sig) => activeSignals.contains(sig));
  }
}
