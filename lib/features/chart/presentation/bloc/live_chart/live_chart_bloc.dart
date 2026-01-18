import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/chart_sync_manager/multi_tf_sync.dart';
import '../../../market/domain/entities/candle.dart';
import 'live_chart_event.dart';
import 'live_chart_state.dart';

class LiveChartBloc extends Bloc<LiveChartEvent, LiveChartState> {
  final MultiTimeframeSync _syncManager = MultiTimeframeSync();

  LiveChartBloc() : super(LiveChartInitial()) {
    on<LiveChartStart>(_onStart);
    on<LiveChartStop>(_onStop);
  }

  Future<void> _onStart(
      LiveChartStart e, Emitter<LiveChartState> emit) async {
    emit(LiveChartLoading());

    await _syncManager.startLive(
      accountId: e.accountId,
      symbol: e.symbol,
      timeframe: e.timeframe,
      onUpdate: (candles) {
        emit(LiveChartLoaded(candles));
      },
    );
  }

  Future<void> _onStop(
      LiveChartStop e, Emitter<LiveChartState> emit) async {
    await _syncManager.stopLive(e.symbol, e.timeframe);
    emit(LiveChartInitial());
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
