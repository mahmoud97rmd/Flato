import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/subscription_manager/subscription_manager.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final SubscriptionManager _subsManager = SubscriptionManager();

  ChartBloc() : super(ChartInitial()) {
    on<StartLiveFeed>((event, emit) {
      final sub = event.stream.listen((data) {
        add(LiveDataArrived(data));
      });
      _subsManager.replace(sub);
    });

    on<LiveDataArrived>((event, emit) {
      emit(ChartUpdated(event.data));
    });
  }

  @override
  Future<void> close() async {
    await _subsManager.dispose();
    return super.close();
  }
}
