import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../market/domain/entities/candle.dart';
import '../../presentation/bloc/replay_bloc.dart';
import '../../presentation/bloc/replay_event.dart';
import '../../presentation/bloc/replay_state.dart';
import '../../../replay/domain/entities/speed.dart';

class ReplayPage extends StatelessWidget {
  final String symbol;
  final String timeframe;

  ReplayPage({required this.symbol, required this.timeframe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Market Replay (\$symbol)")),
      body: Column(
        children: [
          BlocBuilder<ReplayBloc, ReplayState>(
            builder: (context, state) {
              if (state is ReplayLoading) return CircularProgressIndicator();
              if (state is ReplayError) return Text(state.message);
              if (state is ReplayReady || state is ReplayPaused || state is ReplayRunning) {
                final total = (state as dynamic).total;
                final speed = (state as dynamic).speed;
                int index = (state is ReplayRunning) ? state.index : ((state is ReplayPaused) ? state.index : 0);

                return Column(
                  children: [
                    Text("Progress: \$index / \$total"),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(onPressed: () => context.read<ReplayBloc>().add(StartReplay()), child: Text("Start")),
                        ElevatedButton(onPressed: () => context.read<ReplayBloc>().add(PauseReplay()), child: Text("Pause")),
                        ElevatedButton(onPressed: () => context.read<ReplayBloc>().add(StopReplay()), child: Text("Stop")),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Speed:"),
                        DropdownButton<ReplaySpeed>(
                          value: speed,
                          items: ReplaySpeed.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                          onChanged: (s) => context.read<ReplayBloc>().add(ChangeReplaySpeed(s!)),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return ElevatedButton(
                onPressed: () => context.read<ReplayBloc>().add(LoadReplayData(symbol: symbol, timeframe: timeframe)),
                child: Text("Load Data"),
              );
            },
          ),
        ],
      ),
    );
  }
}
