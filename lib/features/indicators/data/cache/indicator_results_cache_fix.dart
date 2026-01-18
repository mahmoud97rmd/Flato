import 'dart:collection';

class IndicatorResultsCacheFix {
  final _cache = HashMap<String, double>();

  void put(String key, double value) => _cache[key] = value;
  double? get(String key) => _cache[key];

  void clear() => _cache.clear();
}
