on<LoadChartHistory>((evt, emit) async {
  try {
    final candles = await repo.getCandles(...);
    emit(ChartLoaded(candles, evt.from, evt.to));
  } catch (e) {
    if (e is RestError) {
      emit(ChartError(e.message));
    } else {
      emit(ChartError("حدث خطأ غير متوقع"));
    }
  }
});
