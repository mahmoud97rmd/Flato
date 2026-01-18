import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/oanda_trade_client.dart';

part 'trading_event.dart';
part 'trading_state.dart';

class TradingBloc extends Bloc<TradingEvent, TradingState> {
  final OandaTradeClient _client = OandaTradeClient();

  TradingBloc() : super(TradingInitial()) {
    on<PlaceMarketOrder>((event, emit) async {
      emit(TradingLoading());
      final success = await _client.marketOrder(
        instrument: event.symbol,
        units: event.units,
        stopLoss: event.stopLoss,
        takeProfit: event.takeProfit,
      );
      emit(success ? TradingSuccess() : TradingFailure());
    });

    on<PlaceLimitOrder>((event, emit) async {
      emit(TradingLoading());
      final success =
          await _client.limitOrder(instrument: event.symbol, units: event.units, price: event.price);
      emit(success ? TradingSuccess() : TradingFailure());
    });
  }
}
