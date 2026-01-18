import '../../../features/trading/domain/order/order.dart';

class RiskAnalyzer {
  final double accountSize;

  RiskAnalyzer(this.accountSize);

  double riskPerTrade(double stopLossPips) {
    return accountSize * (stopLossPips / 100);
  }

  double lotSize(double riskAmount, double pipValue) {
    return riskAmount / pipValue;
  }
}
