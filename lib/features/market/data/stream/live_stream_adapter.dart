import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../core/network/ws/transport/ws_transport.dart';
import '../dtos/ws_tick_dto.dart';
import 'mappers/ws_tick_mapper.dart';
import '../../../../core/network/ws/pipeline/ws_pipeline.dart';

class LiveStreamAdapter {
  final WsTransport _transport;
  final WsPipeline<Map<String, dynamic>> _pipeline;

  Stream<Map<String, dynamic>> get stream => _pipeline.stream!;

  LiveStreamAdapter(this._transport)
      : _pipeline = WsPipeline<Map<String, dynamic>>();

  Future<void> connect({
    required String accountId,
    required String instruments,
    required Map<String, String> headers,
  }) async {
    await _transport.connect(
      accountId: accountId,
      instruments: instruments,
      headers: headers,
      onData: (raw) {
        try {
          final json = raw as Map<String, dynamic>;
          final dto = WsTickDTO.fromJson(json);
          if (dto.type == "PRICE") {
            final candle = WsTickMapper.toCandle(dto);
            _pipeline.push({
              "time": candle.time.toIso8601String(),
              "open": candle.open,
              "high": candle.high,
              "low": candle.low,
              "close": candle.close,
            });
          }
        } catch (_) {
          // تجاهل أي خطأ في Parsing
        }
      },
    );
  }

  void disconnect() {
    _transport.disconnect();
    _pipeline.dispose();
  }
}
