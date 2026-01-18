import '../../../domain/repository/market_repository.dart';
import '../../../../core/models/candle_entity.dart';

class MarketRepositoryImpl implements MarketRepository {
  @override
  Future<List<CandleEntity>> getCandles(String symbol, String timeframe) async {
    // التنفيذ عبر REST
    throw UnimplementedError();
  }

  @override
  Stream<CandleEntity> streamCandles(String symbol, String timeframe) {
    // التنفيذ عبر WebSocket
    throw UnimplementedError();
  }
}
