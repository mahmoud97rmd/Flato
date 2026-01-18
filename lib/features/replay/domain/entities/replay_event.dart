import '../../../market/domain/entities/candle.dart';

/// Replicate an event in the replay (e.g., new candle)
class ReplayEvent {
  final CandleEntity candle;
  final DateTime timestamp; // time at which this should fire in replay

  ReplayEvent({required this.candle, required this.timestamp});
}
