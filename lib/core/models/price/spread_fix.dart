class SpreadCalculator {
  static double forBuy(double ask, double bid) => ask - bid;
  static double forSell(double bid, double ask) => bid - ask;
}
