class AccountModel {
  double balance;
  double equity;
  double marginUsed = 0;
  double leverage = 100;

  AccountModel({
    required this.balance,
    required this.equity,
    this.leverage = 100,
  });

  double get availableMargin => equity - marginUsed;

  bool canOpen(double lotSize, double price) {
    final required = (lotSize * price) / leverage;
    return required <= availableMargin;
  }

  void openPosition(double lotSize, double price) {
    final required = (lotSize * price) / leverage;
    if (!canOpen(lotSize, price)) throw Exception("Insufficient margin");
    marginUsed += required;
  }

  void closePosition(double lotSize, double price) {
    final released = (lotSize * price) / leverage;
    marginUsed -= released;
  }
}
