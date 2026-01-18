import '../../domain/entities/tick.dart';

class TickModel {
  final DateTime time;
  final double bid;
  final double ask;

  TickModel({
    required this.time,
    required this.bid,
    required this.ask,
  });

  factory TickModel.fromJson(Map<String, dynamic> json) {
    // OANDA stream sends "tick" messages with bid/ask
    final time = DateTime.parse(json["time"]);
    final bids = json["bids"];
    final asks = json["asks"];

    double bidPrice = double.parse(bids[0]["price"]);
    double askPrice = double.parse(asks[0]["price"]);

    return TickModel(
      time: time,
      bid: bidPrice,
      ask: askPrice,
    );
  }

  TickEntity toEntity() => TickEntity(
    time: time,
    bid: bid,
    ask: ask,
  );
}
