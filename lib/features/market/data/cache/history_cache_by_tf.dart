import '../../../../core/models/candle_entity.dart';

class HistoryCacheByTimeframe {
  final Map<String, List<CandleEntity>> _cache = {};

  void save(String symbol, String timeframe, List<CandleEntity> data) {
    _cache["$symbol-$timeframe"] = data;
  }

  List<CandleEntity>? load(String symbol, String timeframe) {
    return _cache["$symbol-$timeframe"];
  }

  void clear(String symbol, String timeframe) {
    _cache.remove("$symbol-$timeframe");
  }
}
