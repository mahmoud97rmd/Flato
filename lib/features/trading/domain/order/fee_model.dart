class FeeModel {
  final double commissionPerLot;
  final double spreadCost;

  FeeModel(this.commissionPerLot, this.spreadCost);

  double totalCost(double lots) =>
      commissionPerLot * lots + spreadCost * lots;
}
