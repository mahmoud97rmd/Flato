import 'package:flutter_bloc/flutter_bloc.dart';

part 'indicators_event.dart';
part 'indicators_state.dart';

class IndicatorsBloc
    extends Bloc<IndicatorsEvent, IndicatorsState> {
  IndicatorsBloc() : super(IndicatorsInitial()) {
    on<CalculateIndicators>((event, emit) {
      emit(IndicatorsCalculating());
      final emaShort = event.emaShort;
      final emaLong = event.emaLong;
      final rsi = event.rsi;
      emit(IndicatorsLoaded(
        emaShort: emaShort,
        emaLong: emaLong,
        rsi: rsi,
      ));
    });
  }
}
