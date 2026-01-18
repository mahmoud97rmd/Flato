import 'package:hive/hive.dart';
import '../../../core/models/candle_entity.dart';

part "chart_cache_hive.g.dart";

@HiveType(typeId: 50)
class ChartCacheEntity extends HiveObject {
  @HiveField(0)
  final String symbol;

  @HiveField(1)
  final String timeframe;

  @HiveField(2)
  final List<CandleEntity> candles;

  ChartCacheEntity({
    required this.symbol,
    required this.timeframe,
    required this.candles,
  });
}
