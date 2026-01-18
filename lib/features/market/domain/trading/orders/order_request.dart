class OrderRequest {
  final String instrument;
  final int units; // >0 for buy, <0 for sell
  final String type; // MARKET / LIMIT / STOP
  final String timeInForce; // GTC / FOK / IOC
  final double? price; // Only for LIMIT/STOP

  OrderRequest({
    required this.instrument,
    required this.units,
    required this.type,
    this.timeInForce = "FOK",
    this.price,
  });

  Map<String, dynamic> toJson() {
    final order = {
      "instrument": instrument,
      "units": units.toString(),
      "type": type,
      "timeInForce": timeInForce,
      "positionFill": "DEFAULT",
    };
    if (price != null) order["price"] = price.toString();
    return {"order": order};
  }
}
