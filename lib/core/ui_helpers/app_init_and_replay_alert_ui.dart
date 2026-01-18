import 'package:flutter/material.dart';
import '../../core/execution/offline_alerts_backtest_settings.dart';

/// =======================================================
///   App Initialization (Offline + Settings + Hive)
/// =======================================================

Future<void> initApp() async {
  await OfflineHistoryManager.init();
  await AppSettings.init();
}

/// =======================================================
///   Simple Replay UI
/// =======================================================

Widget replayControls({
  required ReplayEngine engine,
  required VoidCallback onPause,
  required VoidCallback onResume,
  required VoidCallback onStop,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(onPressed: onPause, child: Text("Pause")),
      SizedBox(width: 8),
      ElevatedButton(onPressed: onResume, child: Text("Resume")),
      SizedBox(width: 8),
      ElevatedButton(onPressed: onStop, child: Text("Stop")),
    ],
  );
}

/// =======================================================
///   Simple Alerts UI
/// =======================================================

Widget alertListView(List<Alert> alerts) {
  return ListView.builder(
    itemCount: alerts.length,
    itemBuilder: (ctx, idx) {
      final a = alerts[idx];
      return ListTile(
        title: Text("Alert: \${a.condition}"),
        subtitle: Text("Symbol: \${a.symbol}"),
      );
    },
  );
}

/// =======================================================
///   Backtest Report UI
/// =======================================================

Widget backtestReport({
  required BacktestResult result,
  required Widget equityChart,
}) {
  return Column(
    children: [
      Text("Net Profit: \${result.netProfit}"),
      Text("Drawdown: \${result.maxDrawdown}"),
      Text("Trades: \${result.totalTrades}"),
      SizedBox(height: 12),
      Expanded(child: equityChart),
    ],
  );
}
