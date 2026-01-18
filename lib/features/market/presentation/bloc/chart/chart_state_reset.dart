import 'package:flutter_bloc/flutter_bloc.dart';

class ChartStateReset extends ChartEvent {}

class ChartBlocStateResetFix extends Bloc<ChartEvent, ChartState> {
  ChartBlocStateResetFix(): super(ChartIdle()) {
    on<ChartStateReset>((_, emit) {
      emit(ChartIdle()); // إعادة الحالة
    });
  }
}
