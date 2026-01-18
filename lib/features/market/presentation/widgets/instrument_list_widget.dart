import 'package:flutter/material.dart';
import '../pages/market_chart_page.dart';
import '../pages/backtest/backtest_page.dart';
import '../../data/repositories/market_repository_impl.dart';
import '../../data/datasources/local_storage.dart';

class InstrumentListWidget extends StatelessWidget {
  final List<String> instruments;

  InstrumentListWidget({required this.instruments});

  @override
  Widget build(BuildContext context) {
    final localStorage = LocalStorage();
    final repo = MarketRepositoryImpl(localStorage: localStorage);

    return ListView.builder(
      itemCount: instruments.length,
      itemBuilder: (ctx, i) {
        final symbol = instruments[i];
        return ListTile(
          title: Text(symbol),
          subtitle: Row(
            children: [
              ElevatedButton(
                child: Text("Chart"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MarketChartPage(
                        repository: repo,
                        instrument: symbol,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 8),
              ElevatedButton(
                child: Text("Backtest"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BacktestPage(
                        repository: repo,
                        instrument: symbol,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
