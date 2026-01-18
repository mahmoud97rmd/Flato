import '../../domain/models/candle.dart';
import '../../domain/models/instrument.dart';
import '../../../core/network/rest/rest_client.dart';
import '../../../core/storage/cache/cache_manager.dart';

class MarketRepository {
  final RestClient _client = RestClient();
  final CacheManager _cache = CacheManager.instance;

  Future<List<Instrument>> getInstrumentsCached(
      String accountId) async {
    final key = "instruments_\$accountId";
    final fromCache = await _cache.getInstruments(key);
    if (fromCache != null) {
      return fromCache.cast<Instrument>();
    }

    final data =
        await _client.get("/accounts/\$accountId/instruments");
    final list = (data["instruments"] as List)
        .map((e) => Instrument.fromRest(e))
        .toList();

    await _cache.setInstruments(key, list);
    return list;
  }

  Future<List<Candle>> getCandlesCached(
      String accountId, String instrument, String granularity) async {
    final key = "candles_\$accountId_\$instrument_\$granularity";
    final fromCache = await _cache.getSymbols(key);
    if (fromCache != null) {
      return fromCache.cast<Candle>();
    }

    final raw = await _client.get(
        "/accounts/\$accountId/instruments/\$instrument/candles?granularity=\$granularity&count=500");
    final list = (raw["candles"] as List)
        .map((e) => Candle.fromRestJson(e))
        .toList();

    await _cache.setSymbols(key, list);
    return list;
  }
}
