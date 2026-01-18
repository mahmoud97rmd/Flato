import 'package:hive/hive.dart';

class EventAuditManager2 {
  static Box? _box;

  static Future<Box> _openBox() async {
    if (_box != null && _box!.isOpen) return _box!;
    _box = await Hive.openBox('eventAudit');
    return _box!;
  }

  static Future<void> log(String event) async {
    final b = await _openBox();
    await b.add({'event': event, 'timestamp': DateTime.now().toIso8601String()});
  }

  static Future<List<Map>> getAll() async {
    final b = await _openBox();
    return b.values.cast<Map>().toList();
  }
}
