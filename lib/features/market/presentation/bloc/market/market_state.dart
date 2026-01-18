import 'package:equatable/equatable.dart';
import '../../../domain/models/candle.dart';

abstract class MarketState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MarketIdle extends MarketState {}

class MarketLoadingHistory extends MarketState {}

class MarketHistoryReady extends MarketState {
  final List<Candle> candles;
  MarketHistoryReady(this.candles);

  @override
  List<Object?> get props => [candles];
}

class MarketStreaming extends MarketState {}

class MarketError extends MarketState {
  final String message;
  MarketError(this.message);

  @override
  List<Object?> get props => [message];
}
