import 'dart:async';
import '../network/ws_manager.dart';
import '../../features/market/data/streaming/tick_aggregator.dart';
import '../models/tick_entity.dart';
import '../network/rest_client.dart';

typedef CandleUpdateCallback = void Function(List<dynamic> candles);

class SyncManager {
  final WSManager ws;
  final RestClient rest;
  final TickAggregator aggregator;
  final CandleUpdateCallback onCandle;

  StreamSubscription? _wsSub;

  SyncManager({
    required this.ws,
    required this.rest,
    required this.aggregator,
    required this.onCandle,
  });

  void start() {
    ws.connect();
    _wsSub = ws.stream.listen(_processMessage);
  }

  Future<void> stop() async {
    await _wsSub?.cancel();
    ws.dispose();
  }

  void _processMessage(dynamic data) {
    final tick = TickEntity.fromJson("UNKNOWN", data);
    aggregator.addTick(tick);

    final candles = aggregator.buildCandles();
    if (candles.isNotEmpty) {
      onCandle(candles);
    }
  }
}
