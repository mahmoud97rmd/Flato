import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/mode/app_mode_guard.dart';

class BacktestModeBloc extends Bloc<BacktestEvent, BacktestState> {
  final AppModeGuard _guard;

  BacktestModeBloc(this._guard) : super(BacktestIdle());

  void startBacktest(...) {
    if (!_guard.canEnterBacktest()) return; // لا إعادة Backtest أثناء live
    _guard.enterBacktest();
    // start backtest
  }

  void stopBacktest() {
    _guard.enterLive();
    // stop backtest
  }
}
