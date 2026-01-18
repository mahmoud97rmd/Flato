import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  const ErrorScreen(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.error, size: 64, color: Colors.red),
          SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text("Retry"),
            onPressed: () => Navigator.pop(context),
          ),
        ]),
      ),
    );
  }
}
