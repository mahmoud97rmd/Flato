abstract class LiveChartEvent {}

class LiveChartStart extends LiveChartEvent {
  final String accountId;
  final String symbol;
  LiveChartStart({required this.accountId, required this.symbol});
}

class LiveChartStop extends LiveChartEvent {}
