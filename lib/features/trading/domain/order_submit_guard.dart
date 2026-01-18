class OrderSubmitGuard {
  bool canSubmit(String? symbol) => symbol != null && symbol.isNotEmpty;
}
