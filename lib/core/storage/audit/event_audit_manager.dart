import 'package:hive/hive.dart';

class EventAuditManager {
  static Future<void> log(String event) async {
    final box = await Hive.openBox('eventAudit');
    await box.add({'event': event, 'timestamp': DateTime.now().toIso8601String()});
  }

  static Future<List<Map>> getAll() async {
    final box = await Hive.openBox('eventAudit');
    return box.values.cast<Map>().toList();
  }
}
