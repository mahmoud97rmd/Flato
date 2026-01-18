import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/strategy_builder/presentation/pages/strategy_builder_page.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Strategy builder shows nodes list', (tester) async {
    await tester.pumpWidget(MaterialApp(home: StrategyBuilderPage()));
    expect(find.text('Price Above'), findsOneWidget);
    expect(find.text('EMA Cross Up'), findsOneWidget);
  });
}
