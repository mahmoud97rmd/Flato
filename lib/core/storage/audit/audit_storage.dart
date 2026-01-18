import 'package:hive/hive.dart';
import 'audit_hive.dart';

class AuditStorage {
  static const _box = "audit_box";

  Future<void> logEvent(AuditEntity event) async {
    final box = await Hive.openBox<AuditEntity>(_box);
    await box.add(event);
  }

  Future<List<AuditEntity>> getEvents() async {
    final box = await Hive.openBox<AuditEntity>(_box);
    return box.values.toList();
  }

  Future<void> clear() async {
    final box = await Hive.openBox<AuditEntity>(_box);
    await box.clear();
  }
}
