part of 'stream_bloc.dart';

abstract class StreamState {}

class StreamInitial extends StreamState {}

class StreamConnecting extends StreamState {}

class StreamConnected extends StreamState {}

class StreamCandle extends StreamState {
  final Map<String, dynamic> candle;
  StreamCandle(this.candle);
}

class StreamStopped extends StreamState {}
