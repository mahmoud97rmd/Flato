class LatestPriceHolderFix {
  double? _price;

  void update(double v) => _price = v;
  double? get current => _price;
}
