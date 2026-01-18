import 'package:hive/hive.dart';
import '../models/candle_model.dart';

class CandlesCache {
  final Box<CandleModel> _box = Hive.box<CandleModel>('candles');

  Future<void> cacheCandles(String key, List<CandleModel> candles) async {
    await _box.put(key, candles.map((c) => c.toJson()).toList());
  }

  List<CandleModel>? getCachedCandles(String key) {
    final list = _box.get(key);
    if (list == null) return null;
    return (list as List)
        .map((json) => CandleModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }
}
