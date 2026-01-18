part of 'candles_bloc.dart';

abstract class CandlesState {}
class CandlesInitial extends CandlesState {}
class CandlesLoading extends CandlesState {}
class CandlesLoaded extends CandlesState {
  final List<Map<String, dynamic>> raw;
  CandlesLoaded(this.raw);
}
class CandlesError extends CandlesState {
  final String message;
  CandlesError(this.message);
}
