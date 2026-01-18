import 'dart:async';

class BacktestEngineFix {
  bool _cancel = false;
  final StreamController<double> equityStream = StreamController.broadcast();

  void cancel() => _cancel = true;

  Future<void> run(List dataset) async {
    double equity = 0.0;

    for (final data in dataset) {
      if (_cancel) break;

      // update indicators safely
      final signals = computeSignals(data);

      // execute trades
      for (final sig in signals) {
        equity += executeTrade(sig);
      }

      equityStream.add(equity);

      // yield control to avoid blocking
      await Future.delayed(Duration(milliseconds: 1));
    }
  }

  void dispose() {
    equityStream.close();
  }

  List computeSignals(dynamic data) => [];
  double executeTrade(dynamic sig) => 0.0;
}
