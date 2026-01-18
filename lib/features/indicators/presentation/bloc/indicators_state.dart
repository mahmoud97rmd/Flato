part of 'indicators_bloc.dart';

abstract class IndicatorsState {}

class IndicatorsInitial extends IndicatorsState {}

class IndicatorsCalculating extends IndicatorsState {}

class IndicatorsLoaded extends IndicatorsState {
  final List<double> emaShort;
  final List<double> emaLong;
  final List<double> rsi;

  IndicatorsLoaded({
    required this.emaShort,
    required this.emaLong,
    required this.rsi,
  });
}
