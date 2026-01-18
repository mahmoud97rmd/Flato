enum SmartAlertType {
  rsiBelow,
  macdCrossUp,
  bollingerBreakoutUpper,
}

class SmartAlertCondition {
  final SmartAlertType type;
  final int durationSeconds;
  final double threshold;

  SmartAlertCondition({
    required this.type,
    required this.durationSeconds,
    required this.threshold,
  });
}

class SmartAlert {
  final SmartAlertCondition condition;
  final String instrument;
  bool isTriggered = false;

  SmartAlert({required this.condition, required this.instrument});
}
