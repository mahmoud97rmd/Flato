import '../../../domain/alerts/price_alert.dart';

abstract class AlertEvent {}

class AddPriceAlert extends AlertEvent {
  final PriceAlert alert;
  AddPriceAlert(this.alert);
}

class RemovePriceAlert extends AlertEvent {
  final int index;
  RemovePriceAlert(this.index);
}

class CheckPriceAlerts extends AlertEvent {
  final double currentPrice;
  CheckPriceAlerts(this.currentPrice);
}
