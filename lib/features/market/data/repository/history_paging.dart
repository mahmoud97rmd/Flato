import '../../../../core/models/candle_entity.dart';
import '../../../domain/repository/market_repository.dart';

class HistoryPaging {
  final MarketRepository repo;

  HistoryPaging(this.repo);

  Future<List<CandleEntity>> fetchAll(
      String symbol, String timeframe) async {
    List<CandleEntity> all = [];
    int page = 0;
    while (true) {
      final chunk = await repo.fetchHistoryPage(symbol, timeframe, page++);
      if (chunk.isEmpty) break;
      all.addAll(chunk);
    }
    return all;
  }
}
