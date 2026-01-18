import 'package:hive/hive.dart';

class EventAuditManager3 {
  static Box? _box;

  static Future<Box> _openBox() async {
    if (_box != null && _box!.isOpen) return _box!;
    _box = await Hive.openBox('eventAudit');
    return _box!;
  }

  static Future<void> log(String event) async {
    final box = await _openBox();
    final timestamp = DateTime.now().toUtc().toIso8601String();
    await box.add({'event': event, 'timestamp': timestamp});
  }

  static Future<List<Map>> getAllSorted() async {
    final box = await _openBox();
    final values = box.values.cast<Map>().toList();
    values.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
    return values;
  }
}
