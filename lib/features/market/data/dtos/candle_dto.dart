import 'package:meta/meta.dart';

class CandleDTO {
  final String time;
  final Map<String, dynamic>? mid;
  final Map<String, dynamic>? bid;
  final Map<String, dynamic>? ask;
  final int? volume;

  CandleDTO({
    required this.time,
    this.mid,
    this.bid,
    this.ask,
    this.volume,
  });

  factory CandleDTO.fromJson(Map<String, dynamic> json) {
    return CandleDTO(
      time: json["time"] as String,
      mid: json["mid"] as Map<String, dynamic>?,
      bid: json["bid"] as Map<String, dynamic>?,
      ask: json["ask"] as Map<String, dynamic>?,
      volume: json["volume"] is int ? json["volume"] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "time": time,
      if (mid != null) "mid": mid,
      if (bid != null) "bid": bid,
      if (ask != null) "ask": ask,
      if (volume != null) "volume": volume,
    };
  }
}
