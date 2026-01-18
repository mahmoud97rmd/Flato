import 'package:flutter/material.dart';
import '../../domain/order_book.dart';

class OrderBookView extends StatelessWidget {
  final OrderBook book;
  OrderBookView(this.book);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: ListView(
          children: book.bids.map((l) => Text("Bid ${l.price}: ${l.volume}")).toList(),
        )),
        Expanded(child: ListView(
          children: book.asks.map((l) => Text("Ask ${l.price}: ${l.volume}")).toList(),
        )),
      ],
    );
  }
}
