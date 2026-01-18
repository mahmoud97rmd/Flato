part of 'trading_bloc.dart';

abstract class TradingState {}

class TradingInitial extends TradingState {}

class TradingLoading extends TradingState {}

class TradingSuccess extends TradingState {}

class TradingFailure extends TradingState {}
