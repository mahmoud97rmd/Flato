import '../../../domain/fsm/strategy_fsm.dart';

class StrategyBloc {
  final StrategyFSM fsm = StrategyFSM();

  void start() {
    fsm.transitionTo(StrategyState.initializing);
    // تحميل البيانات
    fsm.transitionTo(StrategyState.active);
  }

  void stop() {
    fsm.transitionTo(StrategyState.paused);
  }
}
