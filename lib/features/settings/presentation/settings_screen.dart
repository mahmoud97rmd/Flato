import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الإعدادات")),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text("الوضع الليلي"),
            value: true,
            onChanged: (val) {},
          ),
          ListTile(
            title: Text("لون الشمعة الصاعدة"),
            trailing: CircleAvatar(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }
}
