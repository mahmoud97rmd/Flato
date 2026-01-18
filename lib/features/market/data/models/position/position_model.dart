class PositionModel {
  final String instrument;
  final double units;
  final double unrealizedPL;
  final double averagePrice;
  final double? stopLoss;
  final double? takeProfit;

  PositionModel({
    required this.instrument,
    required this.units,
    required this.unrealizedPL,
    required this.averagePrice,
    this.stopLoss,
    this.takeProfit,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      instrument: json["instrument"],
      units: double.parse(json["units"].toString()),
      unrealizedPL: double.parse(json["unrealizedPL"].toString()),
      averagePrice: double.parse(json["averagePrice"].toString()),
      stopLoss: json["stopLoss"] != null ? double.parse(json["stopLoss"].toString()) : null,
      takeProfit: json["takeProfit"] != null ? double.parse(json["takeProfit"].toString()) : null,
    );
  }
}
