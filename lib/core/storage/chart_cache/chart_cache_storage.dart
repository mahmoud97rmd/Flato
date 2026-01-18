import 'package:hive/hive.dart';
import 'chart_cache_hive.dart';

class ChartCacheStorage {
  static const _box = "chart_cache_box";

  Future<void> save(
      String symbol, String timeframe, List<CandleEntity> candles) async {
    final box = await Hive.openBox<ChartCacheEntity>(_box);
    await box.put("${symbol}_$timeframe",
        ChartCacheEntity(symbol: symbol, timeframe: timeframe, candles: candles));
  }

  Future<List<CandleEntity>> get(String symbol, String timeframe) async {
    final box = await Hive.openBox<ChartCacheEntity>(_box);
    final entity = box.get("${symbol}_$timeframe");
    return entity?.candles ?? [];
  }

  Future<void> clear() async {
    final box = await Hive.openBox<ChartCacheEntity>(_box);
    await box.clear();
  }
}
