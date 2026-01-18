import 'package:hive/hive.dart';
import 'cache_strategy.dart';
import 'ttl_cache.dart';

class CacheManager {
  static final _inst = CacheManager._();
  CacheManager._();

  static CacheManager get instance => _inst;

  late CacheStrategy _symbolsCache;
  late CacheStrategy _instrumentsCache;

  Future<void> init() async {
    final symBox = Hive.box("cache_symbols");
    _symbolsCache = TtlCache(symBox, ttl: Duration(minutes: 10));

    final insBox = Hive.box("cache_instruments");
    _instrumentsCache = TtlCache(insBox, ttl: Duration(minutes: 30));
  }

  Future<List<String>?> getSymbols(String key) =>
      _symbolsCache.read(key);

  Future<void> setSymbols(String key, List<String> val) =>
      _symbolsCache.write(key, val);

  Future<void> deleteSymbols(String key) =>
      _symbolsCache.delete(key);

  Future<List<dynamic>?> getInstruments(String key) =>
      _instrumentsCache.read(key);

  Future<void> setInstruments(String key, List<dynamic> val) =>
      _instrumentsCache.write(key, val);

  Future<void> deleteInstruments(String key) =>
      _instrumentsCache.delete(key);
}
