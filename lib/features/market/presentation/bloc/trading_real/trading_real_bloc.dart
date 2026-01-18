import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/market_repository.dart';
import '../../../domain/trading/orders/order_request.dart';
import 'trading_real_event.dart';
import 'trading_real_state.dart';

class TradingRealBloc extends Bloc<TradingRealEvent, TradingRealState> {
  final MarketRepository repository;

  TradingRealBloc(this.repository) : super(RealTradingIdle()) {
    on<SubmitRealOrder>(_onSubmitOrder);
  }

  Future<void> _onSubmitOrder(
    SubmitRealOrder event,
    Emitter<TradingRealState> emit,
  ) async {
    emit(RealTradingInProgress());
    try {
      final res = await repository.executeOrder(event.order);
      emit(RealTradingSuccess(res));
    } catch (e) {
      emit(RealTradingError("Failed to execute real order: \$e"));
    }
  }
}
