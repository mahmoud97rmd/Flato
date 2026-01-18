abstract class ReplayEvent {}
class StartReplay extends ReplayEvent {
  final DateTime from;
  final DateTime to;
  final double speed;

  StartReplay({required this.from, required this.to, this.speed = 1});
}
class PauseReplay extends ReplayEvent {}
class ResumeReplay extends ReplayEvent {}
class StopReplay extends ReplayEvent {}
