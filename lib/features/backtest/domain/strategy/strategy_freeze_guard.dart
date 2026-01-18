class StrategyFreezeGuard {
  bool _frozen = false;

  void freeze() => _frozen = true;
  void unfreeze() => _frozen = false;

  bool get isFrozen => _frozen;
}
