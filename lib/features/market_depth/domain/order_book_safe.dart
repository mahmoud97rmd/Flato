import 'order_book.dart';

class OrderBookSafe {
  static OrderBook empty() =>
      OrderBook(bids: const [], asks: const []);
}
