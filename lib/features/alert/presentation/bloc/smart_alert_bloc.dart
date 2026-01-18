import 'package:flutter_bloc/flutter_bloc.dart';
import 'smart_alert_event.dart';
import 'smart_alert_state.dart';

class SmartAlertBloc extends Bloc<SmartAlertEvent, SmartAlertState> {
  final Map<String, String> _rules = {};

  SmartAlertBloc() : super(AlertInitial()) {
    on<AddAlertRule>(_onAddRule);
    on<RemoveAlertRule>(_onRemoveRule);
    on<CheckAlerts>(_onCheck);
  }

  void _onAddRule(AddAlertRule event, Emitter<SmartAlertState> emit) {
    _rules[event.id] = event.condition;
    emit(AlertRuleAdded());
  }

  void _onRemoveRule(RemoveAlertRule event, Emitter<SmartAlertState> emit) {
    _rules.remove(event.id);
    emit(AlertRuleRemoved());
  }

  void _onCheck(CheckAlerts event, Emitter<SmartAlertState> emit) {
    try {
      // simple evaluator placeholder
      final triggered = _rules.entries
          .where((e) => event.candle.toString().contains(e.value))
          .map((e) => e.key)
          .toList();

      for (final id in triggered) {
        emit(AlertTriggered(id));
      }
    } catch (e) {
      emit(AlertError(e.toString()));
    }
  }
}
