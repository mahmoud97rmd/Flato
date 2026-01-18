part of 'candles_bloc.dart';

abstract class CandlesEvent {}
class LoadCandles extends CandlesEvent {
  final String symbol;
  final String timeframe;
  LoadCandles(this.symbol, this.timeframe);
}
