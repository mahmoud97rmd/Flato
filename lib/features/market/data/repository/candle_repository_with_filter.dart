import '../../../../core/filters/candle_outlier_filter.dart';
import '../../../../core/models/candle_entity.dart';

class CandleRepositoryWithFilter {
  final CandleOutlierFilter filter = CandleOutlierFilter();

  Future<List<CandleEntity>> fetchCandles(String symbol, String timeframe) async {
    // مثال استرجاع من API
    final raw = await getRawCandlesFromApi(symbol, timeframe);

    // التصفية
    final cleaned = raw.where((c) => filter.isValid(c)).toList();

    return cleaned;
  }

  Future<List<CandleEntity>> getRawCandlesFromApi(String symbol, String timeframe) async {
    // Placeholder
    return [];
  }
}
