class AlertRateLimiter {
  DateTime? lastTriggered;

  bool canTrigger(Duration minGap) {
    final now = DateTime.now();
    if (lastTriggered == null ||
        now.difference(lastTriggered!) >= minGap) {
      lastTriggered = now;
      return true;
    }
    return false;
  }
}
