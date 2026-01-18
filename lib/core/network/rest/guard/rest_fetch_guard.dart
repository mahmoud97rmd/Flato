class RestFetchGuard {
  final Map<String, dynamic> _cache = {};

  bool shouldFetch(String key) => !_cache.containsKey(key);

  void save(String key, dynamic value) => _cache[key] = value;

  dynamic get(String key) => _cache[key];
}
