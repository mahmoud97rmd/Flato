import '../candle_entity.dart';

class CandleFactory {
  static CandleEntity fromJson(Map<String, dynamic>? json) {
    return CandleEntity(
      timeUtc: DateTime.tryParse(json?['time'] ?? '') ?? DateTime.now().toUtc(),
      open: (json?['open'] as num?)?.toDouble() ?? 0.0,
      high: (json?['high'] as num?)?.toDouble() ?? 0.0,
      low: (json?['low'] as num?)?.toDouble() ?? 0.0,
      close: (json?['close'] as num?)?.toDouble() ?? 0.0,
      volume: (json?['volume'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
