import 'package:flutter/material.dart';

class SignalsPanel extends StatelessWidget {
  final List<String> signals;

  SignalsPanel(this.signals);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: signals.map((s) => Text(s, style: TextStyle(fontSize: 14))).toList(),
    );
  }
}
