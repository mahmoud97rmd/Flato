import 'package:hive/hive.dart';
import 'dart:convert';

class AuditLogger {
  static const _box = "audit_logs";

  static Future<void> init() async {
    await Hive.openBox(_box);
  }

  static void log(String event, dynamic payload) {
    final box = Hive.box(_box);
    box.add({
      "timestamp": DateTime.now().toIso8601String(),
      "event": event,
      "payload": jsonEncode(payload),
    });
  }

  static List<dynamic> getAllLogs() {
    final box = Hive.box(_box);
    return box.values.toList();
  }
}
