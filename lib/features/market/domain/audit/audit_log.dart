enum AuditType {
  tradeExecuted,
  tradeClosed,
  apiError,
  strategyChanged,
  settingsChanged,
  websocketConnected,
  websocketDisconnected,
  general,
}

class AuditLog {
  final DateTime timestamp;
  final AuditType type;
  final String message;
  final Map<String, dynamic>? data;

  AuditLog({
    required this.timestamp,
    required this.type,
    required this.message,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      "timestamp": timestamp.toIso8601String(),
      "type": type.toString(),
      "message": message,
      "data": data,
    };
  }

  factory AuditLog.fromJson(Map<String, dynamic> json) {
    return AuditLog(
      timestamp: DateTime.parse(json["timestamp"]),
      type: AuditType.values.firstWhere(
        (e) => e.toString() == json["type"],
        orElse: () => AuditType.general,
      ),
      message: json["message"],
      data: json["data"] != null
          ? Map<String, dynamic>.from(json["data"])
          : null,
    );
  }
}
