abstract class SmartAlertState {}

class AlertInitial extends SmartAlertState {}

class AlertRuleAdded extends SmartAlertState {}

class AlertRuleRemoved extends SmartAlertState {}

class AlertTriggered extends SmartAlertState {
  final String id;
  AlertTriggered(this.id);
}

class AlertError extends SmartAlertState {
  final String message;
  AlertError(this.message);
}
