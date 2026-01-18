import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/audit/audit_repository.dart';
import 'audit_event.dart';
import 'audit_state.dart';

class AuditBloc extends Bloc<AuditEvent, AuditState> {
  final AuditRepository auditRepository;

  AuditBloc(this.auditRepository) : super(AuditIdle()) {
    on<LoadAuditLogs>(_onLoad);
    on<ClearAuditLogs>(_onClear);
  }

  Future<void> _onLoad(LoadAuditLogs event, Emitter<AuditState> emit) async {
    emit(AuditLoading());
    try {
      final logs = auditRepository.getAllLogs();
      emit(AuditLoaded(logs));
    } catch (e) {
      emit(AuditError("Failed to load logs"));
    }
  }

  Future<void> _onClear(ClearAuditLogs event, Emitter<AuditState> emit) async {
    await auditRepository.clearLogs();
    emit(AuditLoaded([]));
  }
}
