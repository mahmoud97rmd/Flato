import 'package:flutter_bloc/flutter_bloc.dart';
import 'chart_event.dart';
import 'chart_state.dart';
import '../../../../core/models/candle_entity.dart';
import '../../../../market/data/repositories/market_repository.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final MarketRepository repository;

  ChartBloc(this.repository) : super(ChartInitial()) {
    on<LoadChartData>(_onLoad);
    on<UpdateVisibleRange>(_onUpdateRange);
    on<RefreshChart>(_onRefresh);
  }

  Future<void> _onLoad(LoadChartData event, Emitter<ChartState> emit) async {
    emit(ChartLoading());
    try {
      final candles = await repository.getHistoricalCandles(
        symbol: event.symbol,
        timeframe: event.timeframe,
      );

      if (candles.isEmpty) {
        return emit(ChartError("No candles returned"));
      }

      emit(ChartLoaded(
        candles: candles,
        visibleMin: candles.first.timeUtc,
        visibleMax: candles.last.timeUtc,
      ));
    } catch (e) {
      emit(ChartError(e.toString()));
    }
  }

  void _onUpdateRange(UpdateVisibleRange event, Emitter<ChartState> emit) {
    final stateNow = state;
    if (stateNow is ChartLoaded) {
      emit(ChartLoaded(
        candles: stateNow.candles,
        visibleMin: event.min,
        visibleMax: event.max,
      ));
    }
  }

  void _onRefresh(RefreshChart event, Emitter<ChartState> emit) {
    final stateNow = state;
    if (stateNow is ChartLoaded) {
      add(LoadChartData(
        symbol: stateNow.candles.first.instrument,
        timeframe: (stateNow.visibleMax.difference(stateNow.visibleMin).inMinutes == 1)
            ? "M1"
            : "Unknown",
      ));
    }
  }
}
