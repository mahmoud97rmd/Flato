import '../time/time_canon.dart';
import 'price/market_price.dart';

class TickEntity {
  final String instrument;
  final DateTime timeUtc;
  final MarketPrice price;

  TickEntity({
    required this.instrument,
    required this.timeUtc,
    required this.price,
  });

  factory TickEntity.fromJson(String instrument, Map<String, dynamic> json) {
    return TickEntity(
      instrument: instrument,
      timeUtc: TimeCanon.toUtc(json['time']),
      price: MarketPrice(
        bid: double.parse(json['bid']),
        ask: double.parse(json['ask']),
      ),
    );
  }
}
