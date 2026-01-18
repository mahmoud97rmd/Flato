enum SourceStatus { healthy, degraded, offline }

class FallbackManager {
  SourceStatus status = SourceStatus.healthy;

  void markDegraded() => status = SourceStatus.degraded;
  void markOffline() => status = SourceStatus.offline;
  void markHealthy() => status = SourceStatus.healthy;

  bool shouldUseRest() => status != SourceStatus.healthy;
}
