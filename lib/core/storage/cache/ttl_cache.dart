import 'dart:convert';
import 'package:hive/hive.dart';
import 'cache_strategy.dart';

class TtlCache<T> implements CacheStrategy<T> {
  final Box _box;
  final Duration ttl;

  TtlCache(this._box, {required this.ttl});

  @override
  Future<void> write(String key, T value) async {
    final wrapper = {
      "ts": DateTime.now().millisecondsSinceEpoch,
      "data": value,
    };
    await _box.put(key, wrapper);
  }

  @override
  Future<T?> read(String key) async {
    final stored = _box.get(key);
    if (stored == null) return null;
    final ts = stored["ts"] as int;
    final diff =
        DateTime.now().millisecondsSinceEpoch - ts;
    if (Duration(milliseconds: diff) > ttl) {
      await _box.delete(key);
      return null;
    }
    return stored["data"] as T;
  }

  @override
  Future<void> delete(String key) async => _box.delete(key);

  @override
  bool shouldInvalidate(String key) {
    return !_box.containsKey(key);
  }
}
