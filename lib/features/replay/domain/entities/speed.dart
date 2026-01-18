enum ReplaySpeed {
  x1,
  x2,
  x5,
  x10,
}

extension SpeedMultiplier on ReplaySpeed {
  double get multiplier {
    switch (this) {
      case ReplaySpeed.x2:
        return 2.0;
      case ReplaySpeed.x5:
        return 5.0;
      case ReplaySpeed.x10:
        return 10.0;
      case ReplaySpeed.x1:
      default:
        return 1.0;
    }
  }
}
