class ReplayEngineCleanupFix {
  bool _playing = false;

  void stop() {
    _playing = false;
  }

  bool get isPlaying => _playing;
}
