import '../../../core/models/candle_entity.dart';

class CandleCacheCleaner {
  final int maxSize;

  CandleCacheCleaner({this.maxSize = 1000});

  List<CandleEntity> clean(List<CandleEntity> candles) {
    if (candles.length <= maxSize) return candles;
    return candles.sublist(candles.length - maxSize);
  }
}
