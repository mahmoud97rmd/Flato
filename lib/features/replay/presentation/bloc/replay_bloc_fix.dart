import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/controller/replay_controller.dart';

class ReplayBlocFix extends Bloc<ReplayEvent, ReplayState> {
  final ReplayController _ctrl = ReplayController();

  ReplayBlocFix(): super(ReplayIdle()) {
    on<StartReplay>((evt, emit) {
      _ctrl.play(evt.stream, (data) => add(ReplayTick(data)));
      emit(ReplayPlaying());
    });

    on<StopReplay>((_, emit) {
      _ctrl.stop();
      emit(ReplayStopped());
    });
  }

  @override
  Future<void> close() async {
    _ctrl.dispose();
    return super.close();
  }
}
