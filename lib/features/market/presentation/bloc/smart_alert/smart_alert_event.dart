import '../../../domain/alerts/smart/smart_alert.dart';

abstract class SmartAlertEvent {}

class AddSmartAlert extends SmartAlertEvent {
  final SmartAlert alert;
  AddSmartAlert(this.alert);
}

class RemoveSmartAlert extends SmartAlertEvent {
  final int index;
  RemoveSmartAlert(this.index);
}

class CheckSmartAlerts extends SmartAlertEvent {
  final dynamic newCandle;
  CheckSmartAlerts(this.newCandle);
}
