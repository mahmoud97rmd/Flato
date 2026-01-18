import 'package:hive/hive.dart';

class BlocStateCache {
  final Box box;

  BlocStateCache(this.box);

  void save(String key, dynamic data) => box.put(key, data);
  dynamic load(String key) => box.get(key);
}
