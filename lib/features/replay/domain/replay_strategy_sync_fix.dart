class ReplayStrategySyncFix {
  bool _ready = false;

  void markReady() => _ready = true;
  bool get isReady => _ready;
}
