double calculateLotSize({
  required double riskPercent,
  required double accountBalance,
  required double stopLossPips,
  required double pipValue,
}) {
  final riskAmt = accountBalance * (riskPercent / 100);
  return riskAmt / (stopLossPips * pipValue);
}
