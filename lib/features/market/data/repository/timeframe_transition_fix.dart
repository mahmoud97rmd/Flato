Future<void> transitionTF(
    String symbol, String fromTF, String toTF) async {
  await manager.dispose(); // close WS
  final hist = await repo.getCandles(symbol, toTF); // load history
  manager.connectForSymbol(symbol, wsUrl(toTF)); // open new WS
}
