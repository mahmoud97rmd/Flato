void _onLoadChartHistory(...) async {
  final history = await repo.getCandles(...);
  emit(ChartLoaded(history, ...));
  // بعد الانتهاء فقط
  _streamSubscription = stream.listen((candle) {
    add(AppendLiveCandle(candle));
  });
}
