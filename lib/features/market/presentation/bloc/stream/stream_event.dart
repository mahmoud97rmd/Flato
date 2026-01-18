part of 'stream_bloc.dart';

abstract class StreamEvent {}

class StartStream extends StreamEvent {
  final String accountId;
  final String symbol;
  final Timeframe timeframe;

  StartStream({
    required this.accountId,
    required this.symbol,
    required this.timeframe,
  });
}

class StreamTickReceived extends StreamEvent {
  final Map<String, dynamic> candle;
  StreamTickReceived(this.candle);
}

class StopStream extends StreamEvent {}
