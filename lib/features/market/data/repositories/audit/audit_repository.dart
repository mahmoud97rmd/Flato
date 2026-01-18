import 'package:hive/hive.dart';
import '../../../domain/audit/audit_log.dart';

class AuditRepository {
  static const String _boxName = "audit_logs";

  Future<void> init() async {
    await Hive.openBox<AuditLog>(_boxName);
  }

  Future<void> addLog(AuditLog log) async {
    final box = Hive.box<AuditLog>(_boxName);
    await box.add(log);
  }

  List<AuditLog> getAllLogs() {
    final box = Hive.box<AuditLog>(_boxName);
    return box.values.toList();
  }

  Future<void> clearLogs() async {
    final box = Hive.box<AuditLog>(_boxName);
    await box.clear();
  }
}
