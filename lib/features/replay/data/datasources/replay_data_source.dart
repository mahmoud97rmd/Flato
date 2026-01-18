import '../../../../market/domain/entities/candle.dart';
import '../../../../market/domain/repositories/market_repository.dart';

class ReplayDataSource {
  final MarketRepository repository;

  ReplayDataSource(this.repository);

  /// Fetch huge range for replay (مثلاً 5000 شمعة)
  Future<List<CandleEntity>> fetchForReplay({
    required String symbol,
    required String timeframe,
    int count = 5000,
  }) async {
    final models = await repository.getHistoricalCandlesPage(
      symbol: symbol,
      timeframe: timeframe,
      count: count,
    );
    return models.map((m) => m.toEntity()).toList();
  }
}
