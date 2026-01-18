import '../../../core/network/ws_manager.dart';
import '../domain/order_book.dart';

class OrderBookWs {
  final WSManager ws;
  OrderBookWs(this.ws);

  void listen(void Function(OrderBook) onUpdate) {
    ws.stream.listen((data) {
      final bids = <OrderBookLevel>[];
      final asks = <OrderBookLevel>[];
      for (var b in data['bids']) {
        bids.add(OrderBookLevel(b[0], b[1]));
      }
      for (var a in data['asks']) {
        asks.add(OrderBookLevel(a[0], a[1]));
      }
      onUpdate(OrderBook(bids: bids, asks: asks));
    });
  }
}
