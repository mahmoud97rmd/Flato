part of 'oanda_bloc.dart';

abstract class OandaState {}
class OandaInitial extends OandaState {}
class OandaLoading extends OandaState {}
class OandaLoaded extends OandaState {
  final List<String> instruments;
  OandaLoaded(this.instruments);
}
class OandaError extends OandaState {
  final String message;
  OandaError(this.message);
}
