import '../time/time_canon.dart';

class CandleEntity {
  final String instrument;
  final DateTime timeUtc;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  CandleEntity({
    required this.instrument,
    required this.timeUtc,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory CandleEntity.fromJson(String instrument, Map<String, dynamic> json) {
    return CandleEntity(
      instrument: instrument,
      timeUtc: TimeCanon.toUtc(json['time']),
      open: double.parse(json['open']),
      high: double.parse(json['high']),
      low: double.parse(json['low']),
      close: double.parse(json['close']),
      volume: double.parse(json['volume']),
    );
  }
}
