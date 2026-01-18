import '../../../domain/entities/candle.dart';
import '../../stream/live_stream_adapter.dart';

class HistoryStreamSyncManager {
  final LiveStreamAdapter _stream;
  List<Candle> _history = [];

  HistoryStreamSyncManager(this._stream);

  void addHistory(List<Candle> hist) {
    _history = hist;
  }

  void startStreaming({
    required String accountId,
    required String instruments,
    required Map<String, String> headers,
    required void Function(Candle) onCandle,
  }) async {
    await _stream.connect(
      accountId: accountId,
      instruments: instruments,
      headers: headers,
    );

    _stream.stream?.listen((raw) {
      final candle = Candle(
        time: DateTime.parse(raw["time"]),
        open: (raw["open"] as num).toDouble(),
        high: (raw["high"] as num).toDouble(),
        low: (raw["low"] as num).toDouble(),
        close: (raw["close"] as num).toDouble(),
      );

      // إذا التاريخ فارغ أو آخر شمعة متساوية بالتوقيت
      if (_history.isEmpty || candle.time.isAfter(_history.last.time)) {
        onCandle(candle);
      }
    });
  }

  void stop() {
    _stream.disconnect();
  }
}
