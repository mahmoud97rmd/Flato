import 'package:flutter/material.dart';
import '../data/alert_log_repository.dart';

class AlertLogScreen extends StatefulWidget {
  @override
  _AlertLogScreenState createState() => _AlertLogScreenState();
}

class _AlertLogScreenState extends State<AlertLogScreen> {
  List<Map> logs = [];

  @override
  void initState() {
    super.initState();
    AlertLogRepository.getLogs().then((value) => setState(() => logs = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("سجل التنبيهات")),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(logs[i]['msg']),
          subtitle: Text(logs[i]['timestamp']),
        ),
      ),
    );
  }
}
