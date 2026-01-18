import 'package:flutter/material.dart';

class MarketInfoScreen extends StatelessWidget {
  final String symbol;
  final String description;

  MarketInfoScreen(this.symbol, this.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(symbol)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text("معلومات عن السوق: $description"),
      ),
    );
  }
}
