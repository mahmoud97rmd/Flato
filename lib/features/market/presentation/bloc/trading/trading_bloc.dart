import 'package:flutter_bloc/flutter_bloc.dart';
import 'trading_event.dart';
import 'trading_state.dart';
import '../../../../market/data/repositories/trading_repository.dart';
import '../../../../market/domain/backtest/backtest_models.dart';

class TradingBloc extends Bloc<TradingEvent, TradingState> {
  final TradingRepository repository;

  TradingBloc(this.repository) : super(TradingInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<ClosePosition>(_onClosePosition);
    on<RefreshPositions>(_onRefreshPositions);
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<TradingState> emit) async {
    emit(TradingLoading());

    try {
      final updatedPositions = await repository.placeOrder(
        instrument: event.instrument,
        side: event.side,
        price: event.price,
        size: event.size,
      );

      emit(TradingOrderSuccess("Order placed successfully"));
      emit(TradingPositionsLoaded(updatedPositions));
    } catch (e) {
      emit(TradingFailure(e.toString()));
    }
  }

  Future<void> _onClosePosition(ClosePosition event, Emitter<TradingState> emit) async {
    emit(TradingLoading());

    try {
      final updatedPositions = await repository.closePosition(event.positionId);
      emit(TradingOrderSuccess("Position closed successfully"));
      emit(TradingPositionsLoaded(updatedPositions));
    } catch (e) {
      emit(TradingFailure(e.toString()));
    }
  }

  Future<void> _onRefreshPositions(RefreshPositions event, Emitter<TradingState> emit) async {
    emit(TradingLoading());

    try {
      final positions = await repository.getOpenPositions();
      emit(TradingPositionsLoaded(positions));
    } catch (e) {
      emit(TradingFailure(e.toString()));
    }
  }
}
