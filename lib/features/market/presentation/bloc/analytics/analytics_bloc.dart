import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/analytics/analytics_calculator.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc() : super(AnalyticsIdle()) {
    on<ComputeAnalytics>(_onCompute);
  }

  void _onCompute(ComputeAnalytics event, Emitter<AnalyticsState> emit) {
    emit(AnalyticsLoading());
    try {
      final result = AnalyticsCalculator.calculate(event.profits);
      emit(AnalyticsLoaded(result));
    } catch (e) {
      emit(AnalyticsError("Analytics compute failed"));
    }
  }
}
