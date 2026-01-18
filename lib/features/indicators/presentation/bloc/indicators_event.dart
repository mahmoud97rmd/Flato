part of 'indicators_bloc.dart';

abstract class IndicatorsEvent {}

class CalculateIndicators extends IndicatorsEvent {
  final List<double> emaShort;
  final List<double> emaLong;
  final List<double> rsi;

  CalculateIndicators({
    required this.emaShort,
    required this.emaLong,
    required this.rsi,
  });
}
