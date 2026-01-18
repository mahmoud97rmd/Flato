enum AppMode { live, backtest }

class AppModeGuard {
  AppMode _current = AppMode.live;

  AppMode get current => _current;

  bool canEnterBacktest() => _current != AppMode.backtest;
  bool canEnterLive() => _current != AppMode.live;

  void enterBacktest() => _current = AppMode.backtest;
  void enterLive() => _current = AppMode.live;
}
