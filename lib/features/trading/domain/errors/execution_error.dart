enum ExecutionErrorType {
  network,
  insufficientMargin,
  rejectedByBroker,
  timeout,
}

class ExecutionError implements Exception {
  final ExecutionErrorType type;
  final String message;

  ExecutionError(this.type, this.message);
}
