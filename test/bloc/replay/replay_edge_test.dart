import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/replay/presentation/bloc/replay_bloc.dart';
import 'package:your_app/features/replay/presentation/bloc/replay_event.dart';
import 'package:your_app/features/replay/presentation/bloc/replay_state.dart';

void main() {
  blocTest<ReplayBloc, ReplayState>(
    'SeekReplay updates index',
    build: () => ReplayBloc(),
    act: (bloc) => bloc.add(SeekReplay(5)),
    expect: () => [isA<ReplayRunning>()],
    verify: (bloc) {
      final state = bloc.state;
      expect((state as ReplayRunning).index, 5);
    },
  );

  blocTest<ReplayBloc, ReplayState>(
    'ChangeReplaySpeed updates speed',
    build: () => ReplayBloc(),
    act: (bloc) => bloc.add(ChangeReplaySpeed(2.0)),
    expect: () => [isA<ReplayRunning>()],
    verify: (bloc) {
      final state = bloc.state;
      expect((state as ReplayRunning).speed, 2.0);
    },
  );
}
