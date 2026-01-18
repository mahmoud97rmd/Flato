import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../market/data/oanda_market_repository.dart';

part 'candles_event.dart';
part 'candles_state.dart';

class CandlesBloc extends Bloc<CandlesEvent, CandlesState> {
  final OandaMarketRepository repo;

  CandlesBloc(this.repo) : super(CandlesInitial()) {
    on<LoadCandles>((event, emit) async {
      emit(CandlesLoading());
      try {
        final data = await repo.getCandles(event.symbol, event.timeframe);
        emit(CandlesLoaded(data));
      } catch (e) {
        emit(CandlesError(e.toString()));
      }
    });
  }
}
