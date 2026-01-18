import '../entities/candle.dart';
import '../repositories/market_repository.dart';

class GetHistoricalCandles {
  final MarketRepository repository;

  GetHistoricalCandles(this.repository);

  Future<List<CandleEntity>> call({
    required String instrument,
    required String granularity,
    required int count,
  }) async {
    return await repository.fetchHistoricalCandles(
      instrument, granularity, count);
  }
}
