import 'package:equatable/equatable.dart';

class Tick extends Equatable {
  final int time; // Unix seconds
  final double bid;
  final double ask;

  const Tick({
    required this.time,
    required this.bid,
    required this.ask,
  });

  factory Tick.fromOandaWs(Map<String, dynamic> json) {
    if (json["type"] != "PRICE") {
      throw FormatException("Not a PRICE message");
    }

    final time = _toUnix(json["time"]);
    final bid = _toDouble(json["bids"][0]["price"]);
    final ask = _toDouble(json["asks"][0]["price"]);

    return Tick(time: time, bid: bid, ask: ask);
  }

  Map<String, dynamic> toMap() {
    return {
      "time": time,
      "bid": bid,
      "ask": ask,
    };
  }

  static int _toUnix(dynamic v) {
    if (v is int) return v;
    if (v is String) {
      return DateTime.parse(v).millisecondsSinceEpoch ~/ 1000;
    }
    throw FormatException("Invalid time: \$v");
  }

  static double _toDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.parse(v);
    throw FormatException("Invalid price: \$v");
  }

  @override
  List<Object?> get props => [time, bid, ask];
}
