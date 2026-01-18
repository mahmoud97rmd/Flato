import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/alerts/price_alert.dart';
import 'alert_event.dart';
import 'alert_state.dart';
import '../../../../core/notifications/notification_service.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final List<PriceAlert> _alerts = [];

  AlertBloc() : super(AlertIdle()) {
    on<AddPriceAlert>((event, emit) {
      _alerts.add(event.alert);
      emit(AlertUpdated(List.from(_alerts)));
    });

    on<RemovePriceAlert>((event, emit) {
      if (event.index >= 0 && event.index < _alerts.length) {
        _alerts.removeAt(event.index);
      }
      emit(AlertUpdated(List.from(_alerts)));
    });

    on<CheckPriceAlerts>((event, emit) {
      final price = event.currentPrice;

      for (var alert in List.from(_alerts)) {
        bool shouldTrigger =
            (alert.triggerAbove && price >= alert.price) ||
            (!alert.triggerAbove && price <= alert.price);

        if (shouldTrigger) {
          NotificationService().showInstantNotification(
            id: DateTime.now().millisecond,
            title: "Price Alert: ${alert.symbol}",
            body:
                "Price reached ${alert.price} (current: ${price.toStringAsFixed(4)})",
          );

          _alerts.remove(alert);
        }
      }

      emit(AlertUpdated(List.from(_alerts)));
    });
  }
}
