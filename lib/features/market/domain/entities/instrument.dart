import 'package:equatable/equatable.dart';

class Instrument extends Equatable {
  final String name;
  final String display;
  final int displayPrecision;
  final int tradeUnitsPrecision;

  const Instrument({
    required this.name,
    required this.display,
    required this.displayPrecision,
    required this.tradeUnitsPrecision,
  });

  @override
  List<Object?> get props =>
      [name, display, displayPrecision, tradeUnitsPrecision];
}
