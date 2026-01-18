abstract class SmartAlertState {}

class SmartAlertIdle extends SmartAlertState {}

class SmartAlertUpdated extends SmartAlertState {
  final List alerts;
  SmartAlertUpdated(this.alerts);
}
