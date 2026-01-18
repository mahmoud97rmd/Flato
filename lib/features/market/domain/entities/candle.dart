import 'package:equatable/equatable.dart';

class Candle extends Equatable {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final int? volume;

  const Candle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.volume,
  });

  @override
  List<Object?> get props =>
      [time, open, high, low, close, volume];
}
