import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  AppErrorWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.error, size: 42, color: Colors.red),
        SizedBox(height: 10),
        Text(message),
      ]),
    );
  }
}
