abstract class CacheStrategy<T> {
  Future<T?> read(String key);
  Future<void> write(String key, T value);
  Future<void> delete(String key);
  bool shouldInvalidate(String key);
}
