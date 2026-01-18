enum MarketType { forex, crypto, commodity, stock }

class Instrument {
  final String symbol;
  final MarketType type;

  Instrument(this.symbol, this.type);
}
