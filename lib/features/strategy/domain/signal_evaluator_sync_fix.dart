import '../../../../core/sync/signal_sync_controller.dart';

class StrategyEvaluatorSyncFix {
  final SignalSyncController _sync = SignalSyncController();

  void evaluate(Map<String, double> indicators, Function applySignal) {
    _sync.addTask(() {
      if (!_sync.isClosed) {
        applySignal(indicators);
      }
    });
  }

  Future<void> dispose() => _sync.dispose();
}
