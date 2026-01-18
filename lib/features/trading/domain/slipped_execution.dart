import 'slippage_model.dart';

class SlippedExecution {
  final SlippageModel slippage;

  SlippedExecution(this.slippage);

  double execute(double intendedPrice) {
    return slippage.apply(intendedPrice);
  }
}
