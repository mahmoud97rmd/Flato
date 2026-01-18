import 'package:hive/hive.dart';

class DrawingStorage {
  static Box? _box;

  static Future<Box> _getBox() async =>
      _box ??= await Hive.openBox('drawings');

  static Future<void> saveDrawing(String key, Map data) async {
    final b = await _getBox();
    await b.put(key, data);
  }

  static Future<Map?> loadDrawing(String key) async {
    final b = await _getBox();
    return b.get(key)?.cast<String, dynamic>();
  }
}
