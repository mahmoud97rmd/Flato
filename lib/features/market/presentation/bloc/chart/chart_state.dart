import '../../../../core/models/candle_entity.dart';

abstract class ChartState {}

class ChartIdle extends ChartState {}

class ChartLoading extends ChartState {}

class ChartLoaded extends ChartState {
  final List<CandleEntity> candles;
  final DateTime from;
  final DateTime to;

  ChartLoaded(this.candles, this.from, this.to);
}

class ChartLiveUpdated extends ChartState {
  final CandleEntity latest;
  ChartLiveUpdated(this.latest);
}

class ChartError extends ChartState {
  final String message;
  ChartError(this.message);
}
