import 'ws_channel_manager.dart';

class WsTimeframeGuard {
  final WSChannelManager manager;

  WsTimeframeGuard(this.manager);

  void switchTimeframe(String newSymbol, String url) {
    manager.dispose(); // إغلاق أي اتصال سابق
    manager.connectForSymbol(newSymbol, url);
  }
}
