import 'package:equatable/equatable.dart';

enum OrderType { market, limit, stop }

class Order extends Equatable {
  final String instrument;
  final OrderType type;
  final int units;
  final double? price;
  final double? stopLoss;
  final double? takeProfit;

  const Order({
    required this.instrument,
    required this.type,
    required this.units,
    this.price,
    this.stopLoss,
    this.takeProfit,
  });

  Map<String, dynamic> toOandaPayload() {
    final base = {
      "instrument": instrument,
      "units": units.toString(),
      "type": type.name.toUpperCase(),
    };

    if (type == OrderType.limit && price != null) {
      base["price"] = price.toString();
    }

    if (stopLoss != null) {
      base["stopLossOnFill"] = {"price": stopLoss.toString()};
    }

    if (takeProfit != null) {
      base["takeProfitOnFill"] = {"price": takeProfit.toString()};
    }

    return {"order": base};
  }

  @override
  List<Object?> get props =>
      [instrument, type, units, price, stopLoss, takeProfit];
}
