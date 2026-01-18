class ModeMutex {
  bool _replayActive = false;

  bool get canStartLive => !_replayActive;

  void startReplay() => _replayActive = true;
  void stopReplay() => _replayActive = false;
}
