Future<List<CandleEntity>> refreshHistory(
    String symbol, String timeframe) async {
  await cache.clear();  // إزالة الكاش القديم
  return await repo.getCandles(symbol, timeframe);
}
