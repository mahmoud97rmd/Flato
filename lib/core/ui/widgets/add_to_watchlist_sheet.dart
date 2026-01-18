import 'package:flutter/material.dart';
import '../../../../core/storage/watchlist.dart';

class AddToWatchlistSheet extends StatelessWidget {
  final String symbol;
  const AddToWatchlistSheet(this.symbol);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text("Add \${symbol} to Watchlist?"),
        SizedBox(height: 10),
        ElevatedButton(
          child: Text("Add"),
          onPressed: () {
            WatchlistManager().add(symbol);
            Navigator.pop(context);
          },
        ),
      ]),
    );
  }
}
