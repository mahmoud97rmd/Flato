import 'package:hive/hive.dart';

class AlertLogRepository {
  static Future<void> log(String msg) async {
    final box = await Hive.openBox('alertLogs');
    await box.add({'msg': msg, 'timestamp': DateTime.now().toIso8601String()});
  }

  static Future<List<Map>> getLogs() async {
    final box = await Hive.openBox('alertLogs');
    return box.values.cast<Map>().toList();
  }
}
