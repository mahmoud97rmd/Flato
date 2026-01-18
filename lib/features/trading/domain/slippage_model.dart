import 'dart:math';

class SlippageModel {
  double maxSlippage = 0.0005;

  double apply(double intendedPrice) {
    final slip = Random().nextDouble() * maxSlippage;
    return intendedPrice + slip;
  }
}
