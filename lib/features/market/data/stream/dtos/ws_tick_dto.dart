class WsTickDTO {
  final String type;
  final String time;
  final List<dynamic>? bids;
  final List<dynamic>? asks;

  WsTickDTO({
    required this.type,
    required this.time,
    this.bids,
    this.asks,
  });

  factory WsTickDTO.fromJson(Map<String, dynamic> json) {
    return WsTickDTO(
      type: json["type"] as String,
      time: json["time"] as String,
      bids: json["bids"] as List<dynamic>?,
      asks: json["asks"] as List<dynamic>?,
    );
  }
}
