import 'lot_manager.dart';

class ExecutionEngine {
  final LotManager lotManager;

  ExecutionEngine(this.lotManager);

  void executeBuy(String symbol) {
    final lot = lotManager.current;
    print("Executing BUY $symbol @ lot $lot");
    // TODO: تنفيذ الصفقة
  }
}
