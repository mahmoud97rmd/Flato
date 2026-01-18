import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:your_app/main.dart';

void main() {
  testWidgets('Offline banner appears', (tester) async {
    await tester.pumpWidget(MyApp());
    // Simulate offline event
    // This part may require dependency injection of NetworkService
  });
}
