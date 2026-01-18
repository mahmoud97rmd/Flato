import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/streaming/live_stream_adapter.dart';
import '../../../../core/bloc/subscriptions/subscription_manager.dart';

abstract class StreamEvent {}

class ConnectStream extends StreamEvent {
  final String accountId;
  final String symbol;
  ConnectStream(this.accountId, this.symbol);
}

class DisconnectStream extends StreamEvent {}

abstract class StreamState {}

class StreamIdle extends StreamState {}

class StreamConnecting extends StreamState {}

class StreamConnected extends StreamState {}

class StreamError extends StreamState {
  final String message;
  StreamError(this.message);
}

class StreamBloc extends Bloc<StreamEvent, StreamState> {
  final LiveStreamAdapter _adapter;
  final SubscriptionManager _subs = SubscriptionManager();

  StreamBloc(this._adapter) : super(StreamIdle()) {
    on<ConnectStream>(_onConnect);
    on<DisconnectStream>(_onDisconnect);
  }

  void _onConnect(
      ConnectStream e, Emitter<StreamState> emit) {
    emit(StreamConnecting());

    _adapter.start(
      accountId: e.accountId,
      symbol: e.symbol,
      timeframe: Timeframe.m1,
    );

    emit(StreamConnected());
  }

  void _onDisconnect(
      DisconnectStream e, Emitter<StreamState> emit) async {
    _adapter.stop();
    await _subs.cancelAll();
    emit(StreamIdle());
  }
}
