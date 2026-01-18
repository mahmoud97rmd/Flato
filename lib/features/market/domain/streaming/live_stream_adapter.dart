import 'dart:convert';
import '../../../core/network/ws/transport/ws_transport.dart';
import '../../../core/network/ws/pipeline/ws_pipeline.dart';
import '../aggregator/candle_aggregator.dart';
import '../timeframes/timeframe.dart';

class LiveStreamAdapter {
  final WsTransport _transport = WsTransport();
  final WsPipeline _pipeline = WsPipeline();
  late CandleAggregator _aggregator;

  Stream<Map<String, dynamic>> get candleStream =>
      _pipeline.stream.map((e) => e as Map<String, dynamic>);

  void start({
    required String accountId,
    required String symbol,
    required Timeframe timeframe,
  }) {
    _aggregator = CandleAggregator(timeframe.duration);

    _transport.connect(
      accountId: accountId,
      instrument: symbol,
      onData: (raw) {
        final decoded = jsonDecode(raw);

        if (decoded["type"] == "PRICE") {
          final tick = {
            "time": decoded["time"] is String
                ? DateTime.parse(decoded["time"])
                        .millisecondsSinceEpoch ~/
                    1000
                : decoded["time"],
            "price": double.parse(decoded["bids"][0]["price"]),
          };

          final candle = _aggregator.processTick(tick);
          _pipeline.push(candle.toMap());
        }
      },
    );
  }

  void stop() {
    _transport.disconnect();
    _pipeline.dispose();
  }
}
