abstract class AuditState {}

class AuditIdle extends AuditState {}

class AuditLoading extends AuditState {}

class AuditLoaded extends AuditState {
  final List logs;
  AuditLoaded(this.logs);
}

class AuditError extends AuditState {
  final String message;
  AuditError(this.message);
}
