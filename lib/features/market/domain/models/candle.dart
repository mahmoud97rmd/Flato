import 'package:equatable/equatable.dart';

class Candle extends Equatable {
  final int time; // Unix seconds (موحد في كل التطبيق)
  final double open;
  final double high;
  final double low;
  final double close;
  final double? volume;

  const Candle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.volume,
  });

  /// Factory آمن من JSON (REST)
  factory Candle.fromRestJson(Map<String, dynamic> json) {
    final candle = json["mid"] ?? json["bid"] ?? json;

    return Candle(
      time: _toUnixSeconds(candle["time"]),
      open: _toDouble(candle["o"]),
      high: _toDouble(candle["h"]),
      low: _toDouble(candle["l"]),
      close: _toDouble(candle["c"]),
      volume: candle["volume"] != null ? _toDouble(candle["volume"]) : null,
    );
  }

  /// Factory آمن من Tick (WebSocket)
  factory Candle.fromTick({
    required int time,
    required double price,
  }) {
    return Candle(
      time: time,
      open: price,
      high: price,
      low: price,
      close: price,
      volume: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "time": time,
      "open": open,
      "high": high,
      "low": low,
      "close": close,
      if (volume != null) "volume": volume,
    };
  }

  Candle copyWith({
    int? time,
    double? open,
    double? high,
    double? low,
    double? close,
    double? volume,
  }) {
    return Candle(
      time: time ?? this.time,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      volume: volume ?? this.volume,
    );
  }

  static int _toUnixSeconds(dynamic v) {
    if (v is int) return v;
    if (v is String) {
      return DateTime.parse(v).millisecondsSinceEpoch ~/ 1000;
    }
    throw FormatException("Invalid time format: \$v");
  }

  static double _toDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.parse(v);
    throw FormatException("Invalid price format: \$v");
  }

  @override
  List<Object?> get props => [time, open, high, low, close, volume];
}
