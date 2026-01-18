import 'package:hive/hive.dart';

class SafeStorage {
  final Box box;

  SafeStorage(this.box);

  T? read<T>(String key) {
    try {
      return box.get(key) as T?;
    } catch (e) {
      return null;
    }
  }

  Future<void> write<T>(String key, T value) async {
    try {
      await box.put(key, value);
    } catch (e) {
      print("Storage error: $e");
    }
  }
}
