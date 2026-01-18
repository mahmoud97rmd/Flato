import '../../../core/storage/chart_cache/chart_cache_storage.dart';
import '../../../core/network/rest_client.dart';
import '../../../core/models/candle_entity.dart';

class MarketRepository {
  final RestClient rest;
  final ChartCacheStorage cache;

  MarketRepository({required this.rest, required this.cache});

  Future<List<CandleEntity>> getHistoricalCandles({
    required String symbol,
    required String timeframe,
  }) async {
    final cached = await cache.get(symbol, timeframe);
    if (cached.isNotEmpty) {
      // return cache while fetching remote update
      _refreshRemote(symbol, timeframe);
      return cached;
    }
    final remote = await _fetchRemote(symbol, timeframe);
    await cache.save(symbol, timeframe, remote);
    return remote;
  }

  Future<void> _refreshRemote(String symbol, String timeframe) async {
    try {
      final remote = await _fetchRemote(symbol, timeframe);
      await cache.save(symbol, timeframe, remote);
    } catch (e) {
      // ignore
    }
  }

  Future<List<CandleEntity>> _fetchRemote(
      String symbol, String timeframe) async {
    final resp = await rest.get("/history/$symbol/$timeframe");
    // parse JSON → List<CandleEntity>
    // implementation depends on API shape
    return [];
  }
}
