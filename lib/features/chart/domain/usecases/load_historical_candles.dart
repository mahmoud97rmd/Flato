import '../../../../core/di/dependency_injection.dart';
import '../../../market/domain/repositories/market_repository.dart';
import '../../../market/domain/entities/candle.dart';

class LoadHistoricalCandles {
  final MarketRepository _repo = di<MarketRepository>();

  Future<List<Candle>> execute(
    String accountId,
    String symbol,
    String timeframe,
  ) {
    return _repo.fetchHistoricalCandles(
      accountId,
      symbol,
      timeframe,
    );
  }
}
