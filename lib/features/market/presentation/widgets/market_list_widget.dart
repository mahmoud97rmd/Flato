import 'package:flutter/material.dart';

class MarketListWidget extends StatelessWidget {
  final List<String> instruments;

  MarketListWidget({required this.instruments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: instruments.length,
      itemBuilder: (ctx, i) {
        final symbol = instruments[i];
        return ListTile(
          title: Text(symbol),
          trailing: Icon(Icons.arrow_forward_ios),
        );
      },
    );
  }
}
