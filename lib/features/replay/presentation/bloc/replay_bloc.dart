import 'package:flutter_bloc/flutter_bloc.dart';
import 'replay_event.dart';
import 'replay_state.dart';
import '../../../domain/replay_engine.dart';
import '../../../domain/replay_state.dart';

class ReplayBloc extends Bloc<ReplayEvent, ReplayStatus> {
  ReplayEngine? engine;

  ReplayBloc() : super(ReplayIdle()) {
    on<StartReplay>(_onStart);
    on<PauseReplay>((_, emit) => emit(ReplayPaused()));
    on<ResumeReplay>((_, emit) => emit(ReplayPlaying()));
    on<StopReplay>((_, emit) => emit(ReplayEnded()));
  }

  void _onStart(StartReplay event, Emitter<ReplayStatus> emit) async {
    // load history from repo
    engine = ReplayEngine([]);
    engine!.setSpeed(event.speed);
    emit(ReplayPlaying());
    engine!.play((c) {
      // dispatch to chart Bloc
    });
  }
}
