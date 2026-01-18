import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/alerts/smart/smart_alert.dart';
import '../../../domain/alerts/smart/engine/smart_alert_engine.dart';
import 'smart_alert_event.dart';
import 'smart_alert_state.dart';

class SmartAlertBloc extends Bloc<SmartAlertEvent, SmartAlertState> {
  final List<CandleEntity> _history = [];
  final List<SmartAlert> _alerts = [];

  SmartAlertBloc() : super(SmartAlertIdle()) {
    on<AddSmartAlert>((event, emit) {
      _alerts.add(event.alert);
      emit(SmartAlertUpdated(List.from(_alerts)));
    });

    on<RemoveSmartAlert>((event, emit) {
      _alerts.removeAt(event.index);
      emit(SmartAlertUpdated(List.from(_alerts)));
    });

    on<CheckSmartAlerts>((event, emit) {
      final engine = SmartAlertEngine(history: _history, activeAlerts: _alerts);
      engine.processNewCandle(event.newCandle);
      emit(SmartAlertUpdated(List.from(_alerts)));
    });
  }
}
