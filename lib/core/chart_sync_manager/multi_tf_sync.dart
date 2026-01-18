import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/timeframes/timeframe_utils.dart';
import '../../features/market/domain/entities/candle.dart';
import '../../features/market/domain/repositories/market_repository.dart';
import '../../core/di/dependency_injection.dart';
import '../../features/market/domain/stream/stream_repository.dart';

/// Manager to handle multi timeframes + history paging + live streaming
class MultiTimeframeSync {
  final MarketRepository _marketRepo = di<MarketRepository>();
  final StreamRepository _streamRepo = di<StreamRepository>();

  /// buffers for each timeframe
  final Map<String, List<Candle>> _historyBuffers = {};
  final Map<String, StreamSubscription> _liveSubs = {};

  /// load historical candles with paging
  Future<List<Candle>> loadHistoryPage({
    required String accountId,
    required String symbol,
    required String timeframe,
    int page = 0,
    int pageSize = 200,
  }) async {
    final total = await _marketRepo.fetchHistoricalCandles(
      accountId,
      symbol,
      timeframe,
    );
    // Simple paging — only returns slice
    final start = page * pageSize;
    final end = (start + pageSize).clamp(0, total.length);
    return total.sublist(start, end);
  }

  /// start live streaming for timeframe
  Future<void> startLive({
    required String accountId,
    required String symbol,
    required String timeframe,
    required void Function(List<Candle>) onUpdate,
  }) async {
    final key = "\$symbol|\$timeframe";

    // load history once first
    final history = await loadHistoryPage(
        accountId: accountId, symbol: symbol, timeframe: timeframe);
    _historyBuffers[key] = history;

    // call once after history loaded
    onUpdate(List.unmodifiable(history));

    // now stream
    await _streamRepo.start(
      accountId: accountId,
      instruments: symbol,
      headers: {"Authorization": "Bearer \${await _getToken()}"},
    );

    // cancel existing subscription if exists
    await _liveSubs[key]?.cancel();

    // subscribe
    _liveSubs[key] = _streamRepo.ticks().listen((raw) {
      try {
        final liveCandle = Candle(
          time: DateTime.parse(raw["time"] as String),
          open: (raw["open"] as num).toDouble(),
          high: (raw["high"] as num).toDouble(),
          low: (raw["low"] as num).toDouble(),
          close: (raw["close"] as num).toDouble(),
        );

        final dur = tfToDuration(timeframe);

        final buff = _historyBuffers[key] ?? [];
        if (buff.isEmpty ||
            liveCandle.time.isAfter(buff.last.time)) {
          final filled = _fillGaps(buff, liveCandle, dur);
          _historyBuffers[key] = filled;
          onUpdate(List.unmodifiable(filled));
        }
      } catch (_) {}
    });
  }

  /// fill any gap between last history candle and next live candle
  List<Candle> _fillGaps(
      List<Candle> history, Candle live, Duration dur) {
    final List<Candle> result = List.of(history);
    DateTime nextExpected =
        history.isEmpty ? live.time : history.last.time.add(dur);

    while (nextExpected.isBefore(live.time)) {
      final c = Candle(
        time: nextExpected,
        open: history.last.close,
        high: history.last.close,
        low: history.last.close,
        close: history.last.close,
      );
      result.add(c);
      nextExpected = nextExpected.add(dur);
    }
    result.add(live);
    return result;
  }

  /// stop streaming for this timeframe
  Future<void> stopLive(String symbol, String timeframe) async {
    final key = "\$symbol|\$timeframe";
    await _liveSubs[key]?.cancel();
    _streamRepo.stop();
    _historyBuffers.remove(key);
  }

  /// simple token loader — replace with secure storage
  Future<String> _getToken() => TokenStorage.getToken();
}
