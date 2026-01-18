import 'package:flutter/material.dart';
import '../../../../core/security/secure_storage_manager.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _tokenCtrl = TextEditingController();
  final _accCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    SecureStorageManager.readOandaToken().then((t) {
      if (t != null) _tokenCtrl.text = t;
    });
    SecureStorageManager.readOandaAccount().then((a) {
      if (a != null) _accCtrl.text = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OANDA Settings")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            controller: _tokenCtrl,
            decoration: InputDecoration(labelText: "API Token"),
          ),
          TextField(
            controller: _accCtrl,
            decoration: InputDecoration(labelText: "Account ID"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await SecureStorageManager.saveOandaToken(_tokenCtrl.text);
              await SecureStorageManager.saveOandaAccount(_accCtrl.text);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Saved OANDA Credentials")));
            },
            child: Text("Save"),
          ),
        ]),
      ),
    );
  }
}
