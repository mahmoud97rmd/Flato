class AlertCondition {
  final String indicator;
  final String operator; // ex: <, >, <=
  final double threshold;
  final Duration duration; // e.g., trigger if condition holds for 2 minutes

  AlertCondition({
    required this.indicator,
    required this.operator,
    required this.threshold,
    required this.duration,
  });
}
