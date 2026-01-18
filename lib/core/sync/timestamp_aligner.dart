class TimestampAligner {
  static double alignWeightedAverage(
      double currentValue,
      DateTime currentTimestamp,
      double latestValue,
      DateTime latestTimestamp) {
    final dt = latestTimestamp.difference(currentTimestamp).inMilliseconds;
    final w1 = dt <= 0 ? 1.0 : 1 / (1 + dt);
    final w2 = 1 - w1;
    return (currentValue * w1) + (latestValue * w2);
  }
}
