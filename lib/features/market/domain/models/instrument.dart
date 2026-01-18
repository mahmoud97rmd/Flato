import 'package:equatable/equatable.dart';

class Instrument extends Equatable {
  final String name;      // مثال: "XAU_USD"
  final String display;   // مثال: "XAUUSD"
  final int displayPrecision;
  final int tradeUnitsPrecision;

  const Instrument({
    required this.name,
    required this.display,
    required this.displayPrecision,
    required this.tradeUnitsPrecision,
  });

  factory Instrument.fromRest(Map<String, dynamic> json) {
    final name = json["name"] as String;
    return Instrument(
      name: name,
      display: name.replaceAll("_", ""),
      displayPrecision: json["displayPrecision"] as int,
      tradeUnitsPrecision: json["tradeUnitsPrecision"] as int,
    );
  }

  @override
  List<Object?> get props =>
      [name, display, displayPrecision, tradeUnitsPrecision];
}
