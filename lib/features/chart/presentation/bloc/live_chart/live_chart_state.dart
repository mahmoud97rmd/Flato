import '../../../../market/domain/entities/candle.dart';

abstract class LiveChartState {}

class LiveChartInitial extends LiveChartState {}

class LiveChartLoading extends LiveChartState {}

class LiveChartLoaded extends LiveChartState {
  final List<Candle> candles;
  LiveChartLoaded(this.candles);
}

class LiveChartError extends LiveChartState {
  final String message;
  LiveChartError(this.message);
}
