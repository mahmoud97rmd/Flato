import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/sync/event_sync_controller.dart';

class ChartBlocSyncFix extends Bloc<ChartEvent, ChartState> {
  final EventSyncController _sync = EventSyncController();

  ChartBlocSyncFix() : super(ChartInitial()) {
    on<NewLiveCandle>((event, emit) {
      _sync.addToQueue(() {
        // process candle update
        emit(ChartUpdated(event.candle));
      });
    });

    on<ZoomPanChanged>((event, emit) {
      _sync.addToQueue(() {
        // process zoom/pan update
        emit(ChartZoomed(event.range));
      });
    });
  }

  @override
  Future<void> close() async {
    await _sync.close();
    return super.close();
  }
}
