abstract class SmartAlertEvent {}

class AddAlertRule extends SmartAlertEvent {
  final String id;
  final String condition; // expression like "RSI < 30"
  AddAlertRule(this.id, this.condition);
}

class RemoveAlertRule extends SmartAlertEvent {
  final String id;
  RemoveAlertRule(this.id);
}

class CheckAlerts extends SmartAlertEvent {
  final dynamic candle; // can be CandleEntity or other
  CheckAlerts(this.candle);
}
