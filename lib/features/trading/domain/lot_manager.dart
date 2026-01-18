class LotManager {
  double lotSize = 1.0;

  void setLot(double l) {
    if (l <= 0) throw ArgumentError("Lot size must be > 0");
    lotSize = l;
  }

  double get current => lotSize;
}
