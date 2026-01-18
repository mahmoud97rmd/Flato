extension TradingBlocStreamLink on TradingBloc {
  void bindMarketStream(Stream<Map<String, dynamic>> stream) {
    stream.listen((candle) {
      add(CheckStrategySignal(candle)); // حدث فحص استراتيجية
    });
  }
}
