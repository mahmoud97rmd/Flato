import 'package:flutter/material.dart';
import '../../../market/presentation/pages/interactive_chart_page.dart';
import '../widgets/portrait_tabs.dart';

class PortraitHomePage extends StatefulWidget {
  final String symbol;
  PortraitHomePage({required this.symbol});

  @override
  _PortraitHomePageState createState() => _PortraitHomePageState();
}

class _PortraitHomePageState extends State<PortraitHomePage> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: [
                  InteractiveChartPage(symbol: widget.symbol),
                  IndicatorsPortraitPage(), // سننشئها بعد قليل
                  OrdersPortraitPage(),     // سننشئها بعد قليل
                  AlertsPortraitPage(),     // سننشئها بعد قليل
                ],
              ),
            ),
            PortraitTabBar(
              currentIndex: _currentTab,
              onTap: (idx) => setState(() => _currentTab = idx),
            ),
          ],
        ),
      ),
    );
  }
}
