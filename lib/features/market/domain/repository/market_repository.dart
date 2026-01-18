import '../../../../core/models/candle_entity.dart';

abstract class MarketRepository {
  Future<List<CandleEntity>> getCandles(String symbol, String timeframe);
  Stream<CandleEntity> streamCandles(String symbol, String timeframe);
}
