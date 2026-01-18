import 'strategy_state.dart';

class StrategyFSM {
  StrategyState _state = StrategyState.idle;
  StrategyState get state => _state;

  void transitionTo(StrategyState next) {
    // منطق انتقال آمن
    if (_state == StrategyState.error && next != StrategyState.idle) return;
    _state = next;
  }

  bool get isRunning => _state == StrategyState.active;
}
