import '../../../domain/alerts/price_alert.dart';

abstract class AlertState {}

class AlertIdle extends AlertState {}

class AlertUpdated extends AlertState {
  final List<PriceAlert> alerts;
  AlertUpdated(this.alerts);
}
