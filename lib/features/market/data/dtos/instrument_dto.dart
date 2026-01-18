class InstrumentDTO {
  final String name;
  final int displayPrecision;
  final int tradeUnitsPrecision;

  InstrumentDTO({
    required this.name,
    required this.displayPrecision,
    required this.tradeUnitsPrecision,
  });

  factory InstrumentDTO.fromJson(Map<String, dynamic> json) {
    return InstrumentDTO(
      name: json["name"] as String,
      displayPrecision: json["displayPrecision"] as int,
      tradeUnitsPrecision:
          json["tradeUnitsPrecision"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "displayPrecision": displayPrecision,
        "tradeUnitsPrecision": tradeUnitsPrecision,
      };
}
