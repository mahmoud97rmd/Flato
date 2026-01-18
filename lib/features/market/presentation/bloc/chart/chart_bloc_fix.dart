import 'package:flutter_bloc/flutter_bloc.dart';

class ChartBlocFix extends Bloc<ChartEvent, ChartState> {
  List<CandleEntity> _candles = [];

  ChartBlocFix() : super(ChartIdle()) {
    on<LoadChartHistory>((evt, emit) {
      _candles = evt.candles;
      emit(ChartLoaded(_candles, evt.from, evt.to));
    });

    on<ClearChart>((_, emit) {
      _candles.clear();
      emit(ChartIdle());
    });
  }
}
