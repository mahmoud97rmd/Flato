import 'package:flutter/material.dart';

class BackHandler extends StatelessWidget {
  final Widget child;
  final VoidCallback onBack;

  BackHandler({required this.child, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onBack();
        return false;
      },
      child: child,
    );
  }
}
