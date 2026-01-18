void safelyUpdateEquity(List signals, double Function() equityCalc) {
  for (final s in signals) {
    executeSignal(s);
  }
  final newEquity = equityCalc();
  // تحديث Equity مرة واحدة بعد تنفيذ كل الإشارات
}
