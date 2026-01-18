class SlippageGuard {
  final double maxSlippage; 

  SlippageGuard(this.maxSlippage);

  double apply(double price, double slippagePct) {
    final change = price * (slippagePct / 100);
    return price + change.clamp(-maxSlippage, maxSlippage);
  }
}
