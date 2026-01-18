import 'fee_model.dart';
import 'order.dart';

class ExecutionWithFees {
  final FeeModel feeModel;

  ExecutionWithFees(this.feeModel);

  double netPnL(double grossPnL, double lots) {
    final cost = feeModel.totalCost(lots);
    return grossPnL - cost;
  }
}
