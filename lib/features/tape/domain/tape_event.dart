class TapeEvent {
  final double price;
  final double volume;
  final DateTime time;
  final String side; // buy/sell

  TapeEvent(this.price, this.volume, this.time, this.side);
}
