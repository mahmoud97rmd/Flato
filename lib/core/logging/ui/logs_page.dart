import 'package:flutter/material.dart';
import '../audit_logger.dart';

class LogsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logs = AuditLogger.getAllLogs();
    return Scaffold(
      appBar: AppBar(title: Text("System Logs")),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (c, i) {
          final item = logs[i];
          return ListTile(
            title: Text(item["event"]),
            subtitle: Text(item["payload"]),
            trailing: Text(item["timestamp"]),
          );
        },
      ),
    );
  }
}
