import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'market_event.dart';
import 'market_state.dart';
import 'market_effect.dart';
import '../../../domain/models/candle.dart';
import '../../../data/market_repository.dart';
import '../../../domain/streaming/live_stream_adapter.dart';
import '../../../../core/bloc/subscriptions/subscription_manager.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final MarketRepository _repo;
  final LiveStreamAdapter _stream;
  final SubscriptionManager _subs = SubscriptionManager();

  MarketBloc(this._repo, this._stream) : super(MarketIdle()) {
    on<LoadHistory>(_onLoadHistory);
    on<StartStreaming>(_onStartStreaming);
    on<StopStreaming>(_onStopStreaming);
  }

  Future<void> _onLoadHistory(
      LoadHistory e, Emitter<MarketState> emit) async {
    emit(MarketLoadingHistory());

    try {
      final candles = await _repo.getCandlesCached(
        e.accountId,
        e.symbol,
        e.timeframe,
      );

      emit(MarketHistoryReady(candles));
    } catch (err) {
      emit(MarketError("Failed to load history"));
    }
  }

  void _onStartStreaming(
      StartStreaming e, Emitter<MarketState> emit) {
    emit(MarketStreaming());

    final sub = _stream.candleStream.listen((candleMap) {
      final candle = Candle(
        time: candleMap["time"],
        open: candleMap["open"],
        high: candleMap["high"],
        low: candleMap["low"],
        close: candleMap["close"],
      );

      add(_MarketTick(candle));
    });

    _subs.add(sub);
  }

  void _onStopStreaming(
      StopStreaming e, Emitter<MarketState> emit) async {
    await _subs.cancelAll();
    emit(MarketIdle());
  }
}

class _MarketTick extends MarketEvent {
  final Candle candle;
  _MarketTick(this.candle);
}
