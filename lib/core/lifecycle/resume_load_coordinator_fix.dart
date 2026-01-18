class ResumeLoadCoordinatorFix {
  bool _historyDone = false;

  void markHistoryDone() => _historyDone = true;

  bool canStartWS() => _historyDone;
}
