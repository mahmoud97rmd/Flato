abstract class ChartEvent {}

class LoadChartHistory extends ChartEvent {
  final String symbol;
  final String timeframe;
  final DateTime from;
  final DateTime to;

  LoadChartHistory(this.symbol, this.timeframe, this.from, this.to);
}

class AppendLiveCandle extends ChartEvent {
  final CandleEntity newCandle;
  AppendLiveCandle(this.newCandle);
}
